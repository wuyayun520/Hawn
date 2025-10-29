import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
              'Privacy Policy',
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
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, participate in challenges, or contact us for support. This may include:\n\n• Account information (username, email address)\n• Profile information and creative content\n• Challenge submissions and interactions\n• Communication data when you contact us\n• Usage data and preferences',
            ),
            
            _buildSection(
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process transactions and send related information\n• Send technical notices, updates, and support messages\n• Respond to your comments and questions\n• Monitor and analyze trends and usage\n• Personalize your experience\n• Detect, prevent, and address technical issues',
            ),
            
            _buildSection(
              '3. Information Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except in the following circumstances:\n\n• With your explicit consent\n• To comply with legal obligations\n• To protect our rights and prevent fraud\n• With service providers who assist us in operating our platform\n• In connection with a business transfer or acquisition',
            ),
            
            _buildSection(
              '4. Data Security',
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.',
            ),
            
            _buildSection(
              '5. Creative Content',
              'Your creative content (challenges, submissions, comments) may be visible to other users of the platform. By sharing content on Hawn, you acknowledge that:\n\n• Your content may be viewed by other users\n• Other users may interact with your content\n• We may feature your content in promotional materials\n• You retain ownership of your original creative work',
            ),
            
            _buildSection(
              '6. Cookies and Tracking',
              'We use cookies and similar tracking technologies to:\n\n• Remember your preferences and settings\n• Analyze how you use our service\n• Provide personalized content\n• Improve our platform functionality\n\nYou can control cookie settings through your browser preferences.',
            ),
            
            _buildSection(
              '7. Third-Party Services',
              'Our service may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies before providing any personal information.',
            ),
            
            _buildSection(
              '8. Children\'s Privacy',
              'Hawn is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),
            
            _buildSection(
              '9. International Users',
              'If you are accessing Hawn from outside the United States, please be aware that your information may be transferred to, stored, and processed in the United States where our servers are located.',
            ),
            
            _buildSection(
              '10. Your Rights',
              'Depending on your location, you may have certain rights regarding your personal information:\n\n• Access to your personal data\n• Correction of inaccurate data\n• Deletion of your data\n• Portability of your data\n• Objection to processing\n• Withdrawal of consent\n\nTo exercise these rights, please contact us using the information provided below.',
            ),
            
            _buildSection(
              '11. Data Retention',
              'We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
            ),
            
            _buildSection(
              '12. Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date. We encourage you to review this Privacy Policy periodically.',
            ),
            
            const SizedBox(height: 30),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions about this Privacy Policy or our privacy practices, please contact us at:\n\nEmail: privacy@hawn.app\nWebsite: www.hawn.app\n\nFor data protection inquiries: dpo@hawn.app',
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
