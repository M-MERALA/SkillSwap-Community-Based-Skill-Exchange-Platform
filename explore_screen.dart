import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/mock_data.dart';
import '../models/community_model.dart';
import 'community_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<CommunityModel> get _filteredCommunities {
    return MockData.communities.where((c) {
      final matchesCategory =
          _selectedCategory == 'All' || c.category == _selectedCategory;
      final matchesSearch =
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF423061),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Community',
          style: GoogleFonts.raleway(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ──────────────────────────────────────────
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (val) =>
                          setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search communities...',
                        hintStyle: GoogleFonts.lato(
                            color: Colors.black45, fontSize: 15),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Mic button (violet circle)
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF423061),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.mic, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // ── Category chips ───────────────────────────────────────
          Container(
            height: 54,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.categories.length,
              itemBuilder: (context, index) {
                final cat = MockData.categories[index];
                final isSelected = _selectedCategory == cat['name'];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat['name'].toString();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF423061)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF423061)
                              : Colors.black26,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${cat['icon']} ${cat['name']}',
                        style: GoogleFonts.publicSans(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── "Results" header + FILTER chip ───────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Results',
                  style: GoogleFonts.raleway(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // FILTER chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFF423061).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tune,
                          size: 14, color: Color(0xFF423061)),
                      const SizedBox(width: 4),
                      Text(
                        'FILTER',
                        style: GoogleFonts.publicSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF423061),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Cards list ───────────────────────────────────────────
          Expanded(
            child: _filteredCommunities.isEmpty
                ? Center(
                    child: Text('No results found',
                        style: GoogleFonts.raleway(
                            fontSize: 16, color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    itemCount: _filteredCommunities.length,
                    itemBuilder: (context, index) {
                      return _buildCard(_filteredCommunities[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ── Image-based Community card design ──────────────────────────
  Widget _buildCard(CommunityModel community) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommunityDetailsScreen(
            title: community.name,
            description: community.description,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top (Banner)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                community.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: const Color(0xFFF0EEF8),
                  child: const Icon(Icons.image, size: 50, color: Color(0xFF423061)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Members Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          community.name,
                          style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EEF8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${community.memberCount} members',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF423061),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Community Description
                  Text(
                    community.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  // Action Button: Ask to Join / Join Community
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => MockData.joinCommunity(community.id));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: community.isJoined
                            ? const Color(0xFFE8E8E8)
                            : const Color(0xFF423061),
                        foregroundColor: community.isJoined
                            ? const Color(0xFF423061)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        community.isJoined ? 'Joined' : 'Join Community',
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
    );
  }
}
