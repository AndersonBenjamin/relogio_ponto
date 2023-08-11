import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relogio_ponto/pages/home_page.dart';

class NaviDrawer extends StatelessWidget {
  const NaviDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              builderHeader(context),
              builderMenuItems(context),
            ],
          ),
        ),
      );
}

Widget builderHeader(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser!;
  return Container(
    color: Colors.deepPurple,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: Column(children: [
      const CircleAvatar(
        radius: (52),
        backgroundImage: AssetImage(
          'lib/images/pessoal.jpeg',
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Anderson',
        style: TextStyle(fontSize: 28, color: Colors.white),
      ),
      Text(
        user.email.toString(),
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    ]),
  );
}

Widget builderMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16, // vertical space
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Favorites'),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.workspaces_outline),
            title: const Text('WorkFlow'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Updatte'),
            onTap: () {},
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.account_tree_outlined),
            title: const Text('Plugins'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            onTap: () {},
          ),
        ],
      ),
    );
