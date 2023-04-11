import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Referensi Utama : https://www.youtube.com/watch?v=d4KFeRdZMcw

class ProfilePage extends StatefulWidget {
  //Referensi : https://stackoverflow.com/questions/62108798/how-to-save-page-state-on-revisit-in-flutter
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _profileImage; // deklarasi null
  final picker = ImagePicker();
  //var myFile = File('file.txt');

  Future _pickImage() async {
    // Referensi : https://medium.com/unitechie/flutter-tutorial-image-picker-from-camera-gallery-c27af5490b74
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  //Referensi : https://stackoverflow.com/questions/62128847/how-to-save-set-image-of-pickedfile-type-to-a-image-in-flutter
  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        _pickImage();
      },
      child: CircleAvatar(
        radius: 80.0,
        backgroundColor: Colors.grey[200],
        backgroundImage: _profileImage != null
            ? FileImage(_profileImage!) as ImageProvider<Object>
            : AssetImage('assets/profile_image.jpg'),
      ),
    );
  }

  @override
  void initState() {
    //menginisialisasi tampilan awal
    super.initState();
    _nameController = TextEditingController(text: 'Anonymous');
    _jobTitleController = TextEditingController(text: 'Software Engineer');
    _emailController = TextEditingController(text: 'email@example.com');
    _phoneController = TextEditingController(text: '+62 823 4761567');
    _profileImage = null;
  }

  //https://stackoverflow.com/questions/59558604/why-do-we-use-the-dispose-method-in-flutter-dart-code
  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  //referensi : https://protocoderspoint.com/flutter-profile-page-ui-design-social-media-2/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildProfileImage(),
            const SizedBox(height: 20.0),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _jobTitleController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Job Title',
              ),
            ),
            TextFormField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _phoneController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => EditProfilePage(
                name: _nameController.text,
                jobTitle: _jobTitleController.text,
                email: _emailController.text,
                phone: _phoneController.text,
              )),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        _nameController.text = result['name']!;
        _jobTitleController.text = result['jobTitle']!;
        _emailController.text = result['email']!;
        _phoneController.text = result['phone']!;

        final snackBar = SnackBar(content: Text('Profile updated!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
}

//Referensi : https://stackoverflow.com/questions/71566069/edit-user-profile-page-and-profile-picture-using-real-time-database-flutter
class EditProfilePage extends StatefulWidget {
  final String name;
  final String jobTitle;
  final String email;
  final String phone;

  const EditProfilePage(
      {super.key,
      required this.name,
      required this.jobTitle,
      required this.email,
      required this.phone});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _jobTitleController = TextEditingController(text: widget.jobTitle);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _saveProfile(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: _jobTitleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Job Title',
                ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final result = {
        'name': _nameController.text,
        'jobTitle': _jobTitleController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      };
      Navigator.pop(context, result);
    }
  }
}
