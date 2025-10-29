import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last updated: October 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 30),
            
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using Hawn ("the App"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),
            
            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily download one copy of Hawn for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose or for any public display\n• Attempt to reverse engineer any software contained in the App\n• Remove any copyright or other proprietary notations from the materials',
            ),
            
            _buildSection(
              '3. Creative Challenge Platform',
              'Hawn is a creative challenge initiation platform that allows users to:\n\n• Create and participate in creative challenges\n• Connect with other creative individuals\n• Share and showcase creative work\n• Build a community around creative expression\n\nUsers are responsible for ensuring their content complies with community guidelines and applicable laws.',
            ),
            
            _buildSection(
              '4. User Content',
              'You retain ownership of any content you create, upload, or share through Hawn. By using our service, you grant us a non-exclusive, royalty-free license to use, display, and distribute your content within the App for the purpose of providing our services.',
            ),
            
            _buildSection(
              '5. Prohibited Uses',
              'You may not use Hawn:\n\n• For any unlawful purpose or to solicit others to perform unlawful acts\n• To violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances\n• To infringe upon or violate our intellectual property rights or the intellectual property rights of others\n• To harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate\n• To submit false or misleading information\n• To upload or transmit viruses or any other type of malicious code',
            ),
            
            _buildSection(
              '6. Privacy Policy',
              'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the App, to understand our practices.',
            ),
            
            _buildSection(
              '7. Termination',
              'We may terminate or suspend your account and bar access to the App immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms.',
            ),
            
            _buildSection(
              '8. Disclaimer',
              'The information on this App is provided on an "as is" basis. To the fullest extent permitted by law, this Company:\n\n• Excludes all representations and warranties relating to this App and its contents\n• Excludes all liability for damages arising out of or in connection with your use of this App',
            ),
            
            _buildSection(
              '9. Governing Law',
              'These Terms shall be interpreted and governed by the laws of the jurisdiction in which our company operates, without regard to its conflict of law provisions.',
            ),
            
            _buildSection(
              '10. Changes to Terms',
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect.',
            ),
            
            const SizedBox(height: 30),
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions about these Terms of Service, please contact us at:\n\nEmail: support@hawn.app\nWebsite: www.hawn.app',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
