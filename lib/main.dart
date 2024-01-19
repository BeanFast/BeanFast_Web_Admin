import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(title: 'Flutter Demo', getPages: [
      GetPage(
        name: '/',
        page: () => LoginForm(),
        binding: LoginFormBindingController(),
      ),
      GetPage(name: '/', page: () => ImageSlider()),
    ]
        // home: LoginForm(),
        );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true; // Add this line

  void _togglePasswordVisibility() {
    // Add this method
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // final Controller c = Get.put(Controller());

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters long';
                  }
                  return null;
                },
                onChanged: (value) =>
                    Get.find<Controller>()._username.value = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    // Add this line
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off, // Change this line
                    ),
                    onPressed: _togglePasswordVisibility, // And this line
                  ),
                ),
                obscureText: _isPasswordHidden,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                onChanged: (value) =>
                    Get.find<Controller>()._password.value = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                    Get.toNamed('/');
                  }
                },
                child: Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.find<Controller>().getData();
                },
                child: Text('Call api'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Slider'),
      ),
      body: Center(
        child: PageView(
          controller: controller,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => Get.back(),
                      child: FractionallySizedBox(
                        child: Container(
                          child: PageView(
                            children: [
                              Image.network(
                                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
                              Image.network(
                                  'https://imgupscaler.com/images/samples/animal-after.webp'),
                              Image.network(
                                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
            ),
            // Add more images as needed
          ],
        ),
      ),
    );
  }
}

class Controller extends GetxController {
  var count = 0.obs;
  increment() => count++;

  var _username = "".obs;
  var _password = "".obs;

  final dio = Dio();
  void getData() async {
    final response = await dio
        .get('https://64880ed40e2469c038fcdaf0.mockapi.io/api/v1/user/1');
    print(response.data.toString());
  }
}

class LoginFormBindingController extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Controller>(() => Controller());
  }
}
