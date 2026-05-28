import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_button.dart';

class SchedulingSheet extends StatefulWidget {
  final String personName;
  const SchedulingSheet({super.key, required this.personName});

  @override
  State<SchedulingSheet> createState() => _SchedulingSheetState();
}

class _SchedulingSheetState extends State<SchedulingSheet> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  
  final List<String> _timeSlots = [
    '09:00 AM', '10:30 AM', '01:00 PM', '02:30 PM', '04:00 PM', '05:30 PM', '07:00 PM'
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF423061),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule Session', style: AppTextStyles.headlineSmall),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Text('Choose a convenient time to swap skills with ${widget.personName}.', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 24),
          
          // Date Selection
          Text('Select Date', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.black45),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Time Selection
          Text('Available Slots', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(
                      time,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
          
          AppButton(
            label: 'Confirm Schedule',
            onPressed: _selectedTime == null ? null : () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text('Session Scheduled!', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Your session with ${widget.personName} is set for ${_selectedDate.day}/${_selectedDate.month} at $_selectedTime.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Great!',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
