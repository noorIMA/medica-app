// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class PrivacyAndSecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy and Security",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Privacy and Security",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(height: 20, thickness: 1),
              Text(
                "Ensuring privacy and security in health apps is of utmost importance due to the sensitive nature of the data they handle. These applications often store and process critical personal information, such as medical histories, genetic data, biometric readings, and daily health logs. To protect this information, health apps must employ advanced encryption methods to secure data both at rest and in transit, ensuring that it cannot be easily intercepted or accessed by unauthorized individuals. Strong access controls are essential, ensuring that only authorized users can access specific data. This can be achieved through multi-factor authentication (MFA), role-based access controls (RBAC), and regular audits to detect and mitigate any potential vulnerabilities.\n\nMoreover, health apps should comply with stringent data protection regulations like the General Data Protection Regulation (GDPR) in Europe and the Health Insurance Portability and Accountability Act (HIPAA) in the United States. These regulations mandate clear guidelines on how personal health data should be collected, stored, and shared, emphasizing the need for user consent and transparency. Users should be thoroughly informed about how their data is being utilized, who has access to it, and the purposes for which it is being shared.\n\nRegular security updates and patches are crucial to protect against emerging threats and vulnerabilities. Health app developers must stay vigilant and proactive, continually updating their security protocols to address new risks. Additionally, implementing anonymization and pseudonymization techniques can further enhance privacy by ensuring that personal identifiers are not directly linked to the data.\n\nBy adopting these comprehensive security and privacy measures, health apps can build trust with their users, fostering a safe and secure environment for managing personal health information. This not only protects users but also enhances the credibility and reliability of the health app industry as a whole.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
