import 'package:flutter/material.dart';
import '../../../../models/character.dart';
import '../initiative/initiative_input.dart';

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
    with SingleTickerProviderStateMixin {
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

    _moveController.addStatusListener((status) {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _moveAnimation,
      builder: (context, child) {
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
                colors: [Color(0xFF2D7C9D), Color(0xFF1F5C77)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
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
              children: [
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
                    children: [
                      _buildPassiveStats(),
                      _buildCurrencies(),
                      _buildAdditionalInfo(),
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
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white70,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.character.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            width: 150, // Fixed width for HP section
            child: _buildInfoRow(
              'HP',
              '${widget.character.currentHealth}/${widget.character.maxHealth}',
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 180, // Fixed width for initiative controls section
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                      children: [
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

  Widget _buildPassiveStats() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildPassiveStat(widget.character.passivePerception, 'PERCEPTION'),
          const SizedBox(width: 8),
          _buildPassiveStat(
              widget.character.passiveInvestigation, 'INVESTIGATION'),
          const SizedBox(width: 8),
          _buildPassiveStat(widget.character.passiveInsight, 'INSIGHT'),
        ],
      ),
    );
  }

  Widget _buildCurrencies() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          _buildCurrencyItem(
              widget.character.currency.platinum, 'PP', Colors.grey[300]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              widget.character.currency.gold, 'GP', Colors.yellow[600]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              widget.character.currency.electrum, 'EP', Colors.blue[200]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              widget.character.currency.silver, 'SP', Colors.grey[400]!),
          const SizedBox(width: 8),
          _buildCurrencyItem(
              widget.character.currency.copper, 'CP', Colors.orange[300]!),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }

  String _getPassiveDescription(String type, int value) {
    switch (type) {
      case 'PERCEPTION':
        return 'Perception passive: $value\nUtilisé pour repérer automatiquement les choses cachées';
      case 'INVESTIGATION':
        return 'Investigation passive: $value\nUtilisé pour remarquer automatiquement les indices et anomalies';
      case 'INSIGHT':
        return 'Intuition passive: $value\nUtilisé pour détecter automatiquement les mensonges et intentions';
      default:
        return '$type: $value';
    }
  }

  Widget _buildPassiveStat(int value, String label) {
    return Tooltip(
      message: _getPassiveDescription(label, value),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrencyDescription(String symbol) {
    switch (symbol) {
      case 'PP':
        return 'Pièces de Platine (Platinum)\n1 PP = 10 GP';
      case 'GP':
        return 'Pièces d\'Or (Gold)\n1 GP = 2 EP';
      case 'EP':
        return 'Pièces d\'Electrum (Electrum)\n1 GP = 2 EP';
      case 'SP':
        return 'Pièces d\'Argent (Silver)\n1 GP = 10 SP';
      case 'CP':
        return 'Pièces de Cuivre (Copper)\n1 SP = 10 CP';
      default:
        return symbol;
    }
  }

  Widget _buildCurrencyItem(int amount, String symbol, Color color) {
    return Tooltip(
      message: _getCurrencyDescription(symbol),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount.toString(),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              symbol,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHealthColor(int current, int max) {
    final percent = (current / max * 100).round();
    if (percent > 75) return const Color(0xFF43A047); // healthy
    if (percent > 50) return const Color(0xFFEF6C00); // injured
    if (percent > 25) return const Color(0xFFD32F2F); // bloodied
    return const Color(0xFF6A1B9A); // critical
  }

  IconData _getHealthIcon(int current, int max) {
    final percent = (current / max * 100).round();
    if (percent > 75) return Icons.favorite;
    if (percent > 50) return Icons.heart_broken;
    if (percent > 25) return Icons.dangerous;
    return Icons.emergency;
  }

  Widget _buildInfoRow(String label, String value) {
    if (label == 'HP') {
      final parts = value.split('/');
      final current = int.parse(parts[0]);
      final max = int.parse(parts[1]);
      final color = _getHealthColor(current, max);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
      children: [
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
