import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/mock_data.dart';
import '../widgets/app_button.dart';

class SocialLinksScreen extends StatefulWidget {
  const SocialLinksScreen({super.key});

  @override
  State<SocialLinksScreen> createState() => _SocialLinksScreenState();
}

class _SocialLinksScreenState extends State<SocialLinksScreen> {
  late Map<String, String> _links;
  final List<String> _platforms = ['LinkedIn', 'GitHub', 'Behance', 'Instagram', 'Twitter', 'Website'];

  @override
  void initState() {
    super.initState();
    _links = Map.from(MockData.currentUser.socialLinks);
  }

  void _addOrEditLink(String platform, {String? currentUrl}) {
    final controller = TextEditingController(text: currentUrl);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$platform Link', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'https://$platform.com/your-profile',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Save Link',
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      _links[platform] = controller.text;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAll() {
    final updatedUser = MockData.currentUser.copyWith(socialLinks: _links);
    MockData.updateCurrentUser(updatedUser);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Social links saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Social Links'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveAll),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Text(
            'Connect your profiles to help others find your work and background.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 30),
          ..._platforms.map((platform) {
            final url = _links[platform];
            return _buildLinkTile(platform, url);
          }),
          const SizedBox(height: 40),
          AppButton(label: 'Save Changes', onPressed: _saveAll),
        ],
      ),
    );
  }

  Widget _buildLinkTile(String platform, String? url) {
    final hasLink = url != null && url.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasLink ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (hasLink ? AppColors.primary : Colors.grey).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconForPlatform(platform),
            color: hasLink ? AppColors.primary : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          platform,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          hasLink ? url : 'Not connected',
          style: GoogleFonts.lato(fontSize: 12, color: hasLink ? AppColors.primary : Colors.black38),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(hasLink ? Icons.edit_outlined : Icons.add_circle_outline, color: hasLink ? Colors.black45 : AppColors.primary),
          onPressed: () => _addOrEditLink(platform, currentUrl: url),
        ),
      ),
    );
  }

  IconData _getIconForPlatform(String platform) {
    switch (platform) {
      case 'LinkedIn': return Icons.business_center_outlined;
      case 'GitHub': return Icons.code_rounded;
      case 'Behance': return Icons.brush_outlined;
      case 'Instagram': return Icons.camera_alt_outlined;
      case 'Twitter': return Icons.alternate_email;
      case 'Website': return Icons.language_rounded;
      default: return Icons.link;
    }
  }
}
