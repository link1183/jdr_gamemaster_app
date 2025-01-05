import 'package:flutter/material.dart';
import 'package:jdr_gamemaster_app/models/app_state.dart';
import 'package:jdr_gamemaster_app/models/classes.dart';
import 'package:jdr_gamemaster_app/screens/character_list/widgets/initiative/initiative_input.dart';
import 'package:provider/provider.dart';
import '../../../../models/character.dart';
import '../../../../models/creature.dart';
import 'character_currencies.dart';
import 'character_creatures.dart';
import 'character_stats.dart';

class CharacterListItem extends StatefulWidget {
  final Character character;
  final TextEditingController controller;
  final VoidCallback onSort;
  final int index;
  final bool showTurnOrder;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final bool hasSameInitiativeAbove;
  final bool hasSameInitiativeBelow;

  const CharacterListItem({
    super.key,
    required this.character,
    required this.controller,
    required this.onSort,
    required this.index,
    required this.showTurnOrder,
    this.onMoveUp,
    this.onMoveDown,
    required this.hasSameInitiativeAbove,
    required this.hasSameInitiativeBelow,
  });

  @override
  State<CharacterListItem> createState() => _CharacterListItemState();
}

class _CharacterListItemState extends State<CharacterListItem>
    with SingleTickerProviderStateMixin<CharacterListItem> {
  late final AnimationController _moveController;
  late final Animation<double> _moveAnimation;
  bool _isMovingUp = false;
  bool _isMovingDown = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _moveAnimation = CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    );

    _moveController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _moveController.reset();
        setState(() {
          _isMovingUp = false;
          _isMovingDown = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  void _handleMoveUp() {
    setState(() {
      _isMovingUp = true;
      _isMovingDown = false;
    });
    _moveController.forward();
    widget.onMoveUp?.call();
  }

  void _handleMoveDown() {
    setState(() {
      _isMovingUp = false;
      _isMovingDown = true;
    });
    _moveController.forward();
    widget.onMoveDown?.call();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleTransformation(Creature? creature) {
    setState(() {
      widget.character.transform(creature);
    });
    Provider.of<AppState>(context, listen: false).notifyCharacterChanged();
  }

  Widget _buildLevelDisplay() {
    final List<Class> classes = widget.character.classes;

    if (classes.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.star_outline,
              size: 14,
              color: Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              'Level ${widget.character.level}',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    final List<Class> sortedClasses = List<Class>.from(classes)
      ..sort((Class a, Class b) => b.level.compareTo(a.level));

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: sortedClasses.map<Widget>((Class c) {
        final String? className = c.definition?.name;
        final String? subClassName = c.subClassDefinition?.name;

        if (className == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                _getClassIcon(className),
                size: 14,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                className,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${c.level}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              if (subClassName != null) ...<Widget>[
                const SizedBox(width: 4),
                Text(
                  '•',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  subClassName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getClassIcon(String className) {
    switch (className.toLowerCase()) {
      case 'barbarian':
        return Icons.sports_kabaddi;
      case 'bard':
        return Icons.music_note;
      case 'cleric':
        return Icons.healing;
      case 'druid':
        return Icons.eco;
      case 'fighter':
        return Icons.sports_martial_arts;
      case 'monk':
        return Icons.self_improvement;
      case 'paladin':
        return Icons.shield;
      case 'ranger':
        return Icons.forest;
      case 'rogue':
        return Icons.flash_on;
      case 'sorcerer':
        return Icons.auto_fix_high;
      case 'warlock':
        return Icons.whatshot;
      case 'wizard':
        return Icons.auto_awesome;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _moveAnimation,
      builder: (BuildContext context, Widget? child) {
        double yOffset = 0.0;
        if (_isMovingUp) {
          yOffset = -8.0 * _moveAnimation.value;
        } else if (_isMovingDown) {
          yOffset = 8.0 * _moveAnimation.value;
        }

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFF2D7C9D), Color(0xFF1F5C77)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                  onTap: _toggleExpanded,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildHeader(),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CharacterStats(character: widget.character),
                      CharacterCurrencies(character: widget.character),
                      CharacterCreatures(
                        creatures: widget.character.creatures,
                        activeTransformation:
                            widget.character.activeTransformation,
                        onTransformationChanged: _handleTransformation,
                      ),
                    ],
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final bool isTransformed = widget.character.activeTransformation != null;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white70,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: <Widget>[
                    SizedBox(
                      width: constraints.maxWidth * 0.25,
                      child: Text(
                        widget.character.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLevelDisplay(),
                    ),
                    if (isTransformed) ...<Widget>[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.transform,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: constraints.maxWidth * 0.2,
                        child: Text(
                          '→ ${widget.character.activeTransformation!.name}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: _buildInfoRow(
              'HP',
              '${widget.character.currentHealth}/${widget.character.maxHealth}',
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.showTurnOrder &&
                    (widget.hasSameInitiativeAbove ||
                        widget.hasSameInitiativeBelow))
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (widget.hasSameInitiativeBelow)
                          _buildArrowButton(
                            Icons.keyboard_arrow_down,
                            _handleMoveDown,
                            _isMovingDown,
                          ),
                        if (widget.hasSameInitiativeAbove)
                          _buildArrowButton(
                            Icons.keyboard_arrow_up,
                            _handleMoveUp,
                            _isMovingUp,
                          ),
                      ],
                    ),
                  ),
                SizedBox(
                  width: 84,
                  child: InitiativeInput(
                    character: widget.character,
                    controller: widget.controller,
                    onSort: widget.onSort,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(int current, int max) {
    final int percent = (current / max * 100).round();
    if (percent > 75) return const Color(0xFF43A047); // healthy
    if (percent > 50) return const Color(0xFFEF6C00); // injured
    if (percent > 25) return const Color(0xFFD32F2F); // bloodied
    return const Color(0xFF6A1B9A); // critical
  }

  IconData _getHealthIcon(int current, int max) {
    final int percent = (current / max * 100).round();
    if (percent > 75) return Icons.favorite;
    if (percent > 50) return Icons.heart_broken;
    if (percent > 25) return Icons.dangerous;
    return Icons.emergency;
  }

  Widget _buildInfoRow(String label, String value) {
    if (label == 'HP') {
      final List<String> parts = value.split('/');
      final int current = int.parse(parts[0]);
      final int max = int.parse(parts[1]);
      final Color color = _getHealthColor(current, max);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'HP',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            _getHealthIcon(current, max),
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton(
      IconData icon, VoidCallback onPressed, bool isActive) {
    return IconButton(
      icon: Icon(
        icon,
        size: 20,
        color: isActive ? Colors.white : Colors.white70,
      ),
      onPressed: onPressed,
      hoverColor: Colors.white24,
      splashRadius: 14,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 16,
      ),
    );
  }
}
