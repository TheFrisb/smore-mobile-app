import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timezone/timezone.dart' as tz;

class TimezonePickerDialog extends StatefulWidget {
  final String? initialValue;

  const TimezonePickerDialog({super.key, this.initialValue});

  @override
  State<TimezonePickerDialog> createState() => _TimezonePickerDialogState();
}

class _TimezonePickerDialogState extends State<TimezonePickerDialog>
    with TickerProviderStateMixin {
  late List<String> _allTimezones;
  late List<String> _filteredTimezones;
  String? _selected;
  String _search = '';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _allTimezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    _filteredTimezones = _allTimezones;
    _selected = widget.initialValue;

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _search = value;
      _filteredTimezones = _allTimezones
          .where((tz) => tz.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    });
  }

  String _getTimezoneDisplayName(String tzName) {
    // Extract a more readable name from the timezone
    final parts = tzName.split('/');
    if (parts.length > 1) {
      return parts.last.replaceAll('_', ' ');
    }
    return tzName.replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400,
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1e2f42),
                  Color(0xFF0D151E),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF0BA5EC).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFF0BA5EC).withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0BA5EC),
                        const Color(0xFF0BA5EC).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          LucideIcons.clock9,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Timezone',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Choose your local timezone',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Search field
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1a2a3a),
                          Color(0xFF223548),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFF0BA5EC).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search timezone...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0BA5EC).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            LucideIcons.search,
                            color: Color(0xFF0BA5EC),
                            size: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: const Color(0xFF0BA5EC).withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ),

                // Current timezone display
                if (widget.initialValue != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0BA5EC).withOpacity(0.1),
                            const Color(0xFF0BA5EC).withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF0BA5EC).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.clock9,
                            size: 16,
                            color: Color(0xFF0BA5EC),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Timezone',
                                  style: TextStyle(
                                    color: Color(0xFF0BA5EC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _getTimezoneDisplayName(widget.initialValue!),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  widget.initialValue!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Results count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.list,
                        size: 16,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_filteredTimezones.length} timezone${_filteredTimezones.length == 1 ? '' : 's'} found',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Timezone list
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF0D151E).withOpacity(0.5),
                    ),
                    child: _filteredTimezones.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.searchX,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No timezones found',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _filteredTimezones.length,
                            itemBuilder: (context, i) {
                              final tzName = _filteredTimezones[i];
                              final isSelected = tzName == _selected;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() => _selected = tzName);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: isSelected
                                            ? LinearGradient(
                                                colors: [
                                                  const Color(0xFF0BA5EC).withOpacity(0.2),
                                                  const Color(0xFF0BA5EC).withOpacity(0.1),
                                                ],
                                              )
                                            : null,
                                        border: isSelected
                                            ? Border.all(
                                                color: const Color(0xFF0BA5EC),
                                                width: 2,
                                              )
                                            : Border.all(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFF0BA5EC)
                                                  : Colors.white.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              LucideIcons.clock9,
                                              size: 16,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _getTimezoneDisplayName(tzName),
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? const Color(0xFF0BA5EC)
                                                        : Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  tzName,
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.5),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isSelected)
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0BA5EC),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                LucideIcons.check,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),

                // Bottom actions
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white.withOpacity(0.7),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selected != null
                              ? () => Navigator.of(context).pop(_selected)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selected != null
                                ? const Color(0xFF0BA5EC)
                                : const Color(0xFF0BA5EC).withOpacity(0.3),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _selected != null ? 'Confirm' : 'Select a timezone',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _selected != null ? Colors.white : Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
