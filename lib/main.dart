import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAxkDHIAMyaYOvXDBd6uJyebEt4_CXxULg",
        authDomain: "dtclub-59eaf.firebaseapp.com",
        projectId: "dtclub-59eaf",
        storageBucket: "dtclub-59eaf.appspot.com",
        messagingSenderId: "966662352995",
        appId: "1:966662352995:web:3bb81165d0bc2459d14856",
        measurementId: "G-21PTV7868X",
        databaseURL: "https://dtclub-59eaf-default-rtdb.firebaseio.com/"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: EmailAuthPage(),
    );
  }
}

class EmailAuthPage extends StatefulWidget {
  @override
  _EmailAuthPageState createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  bool _isLoggedIn = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? _collegeYear;
  String? _branch;
  String? _gender;
  String? _section;
  String? _skill;

  String? _statusMessage;

  final List<String> _collegeYears = ['2nd', '3rd', '4th'];
  final List<String> _branches = [
    'CSE',
    'IT',
    'BT',
    'AI',
    'AIML',
    'DS',
    'M.TECH INT',
    'IOT',
    'ECE',
    'ME',
    'CS'
  ];
  final List<String> _genders = ['MALE', 'FEMALE'];
  final List<String> _sections = ['A', 'B', 'C', 'D', 'E'];
  final List<String> _skills = ['Android Developer','Full Stack Developer','Front-End Developer','Backend Developer','AI/ML Developer',
    'VR Developer','Presenter','Speaker','Designer','BlockChain Developer'];

  void _checkEmail() async {
    String email = _emailController.text;
    if (email.toLowerCase().contains('@niet.co.in')) {
      final splittedEmail = email.split('@');
      String localPart = splittedEmail[0].toLowerCase();

      // Check if the first 4 characters are digits and the last 3 characters are digits, with any characters in between
      RegExp emailPattern = RegExp(r'^\d{4}.*\d{3}$');
      if (emailPattern.hasMatch(localPart)) {
        DataSnapshot snapshot = await _databaseRef.child('users/$localPart').get();
        if (snapshot.exists) {
          _promptPassword(localPart, snapshot);
        } else {
          _promptNewUserDetails(localPart);
        }
      } else {
        setState(() {
          _statusMessage = "Email must be the same assigned by your college";
        });
      }
    } else {
      setState(() {
        _statusMessage = "Email must contain '@niet.co.in'.";
      });
    }
  }


  void _promptPassword(String email, DataSnapshot snapshot) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String enteredPassword = _passwordController.text;
                String storedPassword = snapshot
                    .child('password')
                    .value
                    .toString();
                if (enteredPassword == storedPassword) {
                  setState(() {
                    _isLoggedIn = true; // Set login status to true
                    _statusMessage = "Success! You're logged in.";
                  });
                } else {
                  setState(() {
                    _statusMessage = "Incorrect password. Try again.";
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }


  void _promptNewUserDetails(String email) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Up Your Account'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _collegeYear,
                    hint: Text('Select College Year'),
                    items: _collegeYears.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _collegeYear = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your college year';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _branch,
                    hint: Text('Select Branch'),
                    items: _branches.map((branch) {
                      return DropdownMenuItem(
                        value: branch,
                        child: Text(branch),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _branch = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your branch';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    hint: Text('Select Gender'),
                    items: _genders.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _section,
                    hint: Text('Select Section'),
                    items: _sections.map((section) {
                      return DropdownMenuItem(
                        value: section,
                        child: Text(section),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _section = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your section';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _skill,
                    hint: Text('Select Role'),
                    items: _skills.map((skill) {
                      return DropdownMenuItem(
                        value: skill,
                        child: Text(skill),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _skill = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your role';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String password = _passwordController.text;
                  Map<String, dynamic> userDetails = {
                    'name': _nameController.text,
                    'email': '$email@niet.co.in',
                    'collegeYear': _collegeYear,
                    'branch': _branch,
                    'gender': _gender,
                    'section': _section,
                    'password': password,
                    'skill': _skill,
                  };

                  await _databaseRef.child('users/$email').set(userDetails);

                  setState(() {
                    _statusMessage = "Account created successfully!";
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find My Team for SMART INDIA HACKATHON (SIH) !',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 248, 245, 209),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Text(
                'Welcome to the Team Finder!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Enter your college email below to sign in and find your perfect teammate.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your college email (must include niet.co.in)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkEmail,
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 183, 246, 141),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              if (_isLoggedIn) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindTeammatePage()),
                    );
                  },
                  child: Text('Find Teammate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(200, 198, 230, 236),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
              if (_statusMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _statusMessage!,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 50),
              Divider(color: Colors.grey[300]),
              Text(
                'Designed and Developed by Design Thinking Club',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindTeammatePage extends StatefulWidget {
  @override
  _FindTeammatePageState createState() => _FindTeammatePageState();
}

class _FindTeammatePageState extends State<FindTeammatePage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  String? _selectedYear;
  String? _selectedBranch;
  String? _selectedGender;
  String? _selectedSkill;
  List<Map<String, dynamic>> _teammates = [];
  String? _statusMessage;

  final List<String> _collegeYears = ['Any','2nd', '3rd', '4th'];
  final List<String> _branches = ['Any','CSE', 'IT', 'BT', 'AI', 'AIML', 'DS', 'M.TECH INT','IOT','ECE','ME','CS'];
  final List<String> _genders = ['Any','MALE', 'FEMALE'];
  final List<String> _skills = ['Any','Android Developer','Full Stack Developer','Front-End Developer','Backend Developer','AI/ML Developer',
    'VR Developer','Presenter','Speaker','Designer','BlockChain Developer'];


  void _findTeammates() async {
    try {
      Query query = _databaseRef.child('users');

      if (_selectedYear != null && _selectedYear != 'Any') {
        query = query.orderByChild('collegeYear').equalTo(_selectedYear);
      }

      DataSnapshot snapshot = await query.get();
      List<DataSnapshot> filteredResults = [];

      snapshot.children.forEach((child) {
        bool matchesBranch = _selectedBranch == null || _selectedBranch == 'Any' || child.child('branch').value == _selectedBranch;
        bool matchesGender = _selectedGender == null || _selectedGender == 'Any' || child.child('gender').value == _selectedGender;
        bool matchesSkill = _selectedSkill == null || _selectedSkill == 'Any' || child.child('skill').value == _selectedSkill;

        if (matchesBranch && matchesGender && matchesSkill) {
          filteredResults.add(child);
        }
      });

      setState(() {
        _teammates = filteredResults.map((e) => Map<String, dynamic>.from(e.value as Map)).toList();
        if (_teammates.isEmpty) {
          _statusMessage = 'No developer found';
        } else {
          _statusMessage = null;
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _statusMessage = 'Error fetching data.';
      });
    }
  }


  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Invitation%20to%20Join%20My%20Team&body=Hey%20there,%20let\'s%20team%20up%20for%20Smart%20India%20Hackathon%202024',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find a Teammate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 248, 245, 209),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Select your preferences to find the perfect teammate!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedYear,
              hint: Text('Select College Year'),
              items: _collegeYears.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedBranch,
              hint: Text('Select Branch'),
              items: _branches.map((branch) {
                return DropdownMenuItem(
                  value: branch,
                  child: Text(branch),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBranch = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              hint: Text('Select Gender'),
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedSkill,
              hint: Text('Select Role'),
              items: _skills.map((skill) {
                return DropdownMenuItem(
                  value: skill,
                  child: Text(skill),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSkill = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _findTeammates,
              child: Text('Find Teammates'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 183, 246, 141),
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _teammates.isNotEmpty
                  ? ListView.builder(
                itemCount: _teammates.length,
                itemBuilder: (context, index) {
                  var teammate = _teammates[index];
                  var email = teammate['email'] ?? 'No email';

                  return Card(
                    color: Colors.deepPurple[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        teammate['name'] ?? 'No name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Email: ${teammate['email'] ?? 'No email'}, Role: ${teammate['skill'] ?? 'No skill'}',
                      ),
                      onTap: () => _launchEmail(email),
                    ),
                  );
                },
              )
                  : Card(
                color: Colors.red[50],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    'No developer found',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  subtitle: Text(
                    'Try different filters or invite others to join!',
                    style: TextStyle(color: Colors.red[800]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
