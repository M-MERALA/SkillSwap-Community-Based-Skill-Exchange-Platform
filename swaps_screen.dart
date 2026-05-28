import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/mock_data.dart';
import '../widgets/skill_card.dart';
import 'chat_screen.dart';

class SwapsScreen extends StatefulWidget {
  const SwapsScreen({super.key});

  @override
  State<SwapsScreen> createState() => _SwapsScreenState();
}

class _SwapsScreenState extends State<SwapsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToChat(String otherUserId) {
    try {
      final chat = MockData.chats.firstWhere((c) => c.otherUserId == otherUserId);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final receivedRequests = MockData.swapRequests.where((r) => r.toUserId == MockData.currentUser.id).toList();
    final sentRequests = MockData.swapRequests.where((r) => r.fromUserId == MockData.currentUser.id).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7153B8), Color(0xFF5500FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Community',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 27,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 4,
        shadowColor: Colors.black26,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white, // Changed from yellow to white
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          tabs: const [
            Tab(text: 'Received Swaps'),
            Tab(text: 'Sent Swaps'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Received Tab
          receivedRequests.isEmpty
              ? _buildEmptyState('No received requests yet')
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: receivedRequests.length,
                  itemBuilder: (context, index) {
                    final req = receivedRequests[index];
                    return SwapRequestCard(
                      request: req,
                      isSent: false,
                      onAccept: () {
                        setState(() {
                          MockData.acceptSwapRequest(req.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Swap request accepted!')),
                        );
                      },
                      onDecline: () {
                        setState(() {
                          MockData.declineSwapRequest(req.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Swap request declined.')),
                        );
                      },
                      onMessage: () {
                        final otherUserId = req.fromUserId == MockData.currentUser.id ? req.toUserId : req.fromUserId;
                        _navigateToChat(otherUserId);
                      },
                    );
                  },
                ),
          // Sent Tab
          sentRequests.isEmpty
              ? _buildEmptyState('You haven\'t sent any requests')
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sentRequests.length,
                  itemBuilder: (context, index) {
                    final req = sentRequests[index];
                    return SwapRequestCard(
                      request: req,
                      isSent: true,
                      onMessage: () {
                        final otherUserId = req.fromUserId == MockData.currentUser.id ? req.toUserId : req.fromUserId;
                        _navigateToChat(otherUserId);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
