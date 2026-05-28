import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.raleway(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: MockData.notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: MockData.notifications.length,
              itemBuilder: (context, index) {
                final notification = MockData.notifications[index];
                return _buildNotificationCard(context, notification);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 20),
          Text('No notifications yet', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          SizedBox(height: 10),
          Text('We\'ll notify you when something important happens.', textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.notifications, color: AppColors.primary, size: 20),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(notification['title'], style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(_formatTime(notification['time']), style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 4),
                Text(notification['body'], style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

