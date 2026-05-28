import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/mock_data.dart';
import '../widgets/user_card.dart';
import 'public_profile_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  const SearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchCtrl;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchCtrl = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For this screen, let's filter users instead of skills to match Image 2
    final filteredUsers = MockData.users.where((u) {
      final q = _query.toLowerCase();
      return u.name.toLowerCase().contains(q) || 
             u.skillsOffered.any((s) => s.name.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Purple Header from Image 2
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF7153B8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEBF3),
                      borderRadius: BorderRadius.circular(62),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (val) => setState(() => _query = val),
                            decoration: InputDecoration(
                              hintText: 'Musician',
                              hintStyle: GoogleFonts.lato(color: Colors.black, fontSize: 18),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1), // Square-ish in image
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: const Icon(Icons.search, color: Colors.black, size: 32),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.black, size: 24),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Filter button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF7153B8), width: 1.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.tune, size: 14, color: Color(0xFF423061)),
                          const SizedBox(width: 5),
                          Text(
                            'FILTER',
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF423061),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  if (filteredUsers.isEmpty)
                    const Center(child: Text('No people found matching your search.'))
                  else
                    ...filteredUsers.map((user) => UserCard(
                      user: user,
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => PublicProfileScreen(user: user))
                      ),
                    )),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

