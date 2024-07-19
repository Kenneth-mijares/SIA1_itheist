import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sia/pages/Inventory/Main%20Screen/inventory_page.dart';


import 'Shop/Main Screen/home_page.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  // 1. Nullable user
  User? user;

  @override
  void initState() {
    super.initState();
    // 2. Initialize user in initState
    user = FirebaseAuth.instance.currentUser;
    
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        
        children: [
          /*
          UserAccountsDrawerHeader(
            accountName: const Text("Lorem Ipsum"), // add the name function in firebase
            accountEmail:  Text(user!.email!), // remove const if adding the detailsfrom firebase
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.network(
                'https://avatars.githubusercontent.com/u/75308797?v=4',
                width: 90,
                height: 90,
              )),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d2FsbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&w=1000&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          */

          //shop hub
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text("Shop"),
            onTap: () => 
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const HomePage(), // Replace with your actual HomePage widget
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              )
          ),
          
          //inventory hub
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text("Inventory"),
            onTap: () => 
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const InventoryPage(), // Replace with your actual HomePage widget
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                )

          ),
          
          //customer hub
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Customer"),
            onTap: () {},
          ),
          
          /*
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Customer"),
            onTap: ()  => 
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const StorePage(), // Replace with your actual HomePage widget
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                ),
          ),
          //customer hub
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Customer"),
            onTap: () {},
          ),
          //customer hub
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Customer"),
            onTap: () {},
          ),
          */
          
          
          //analytics hub
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text("Analytics"),
            onTap: () {},
            /*
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: const Center(
                  child: Text(
                    "8",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            */
          ),
          
          
          ///edit if you want or just remove vvv
          
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text("Settings"),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.description),
          //   title: const Text("Policies"),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sign Out"),
            onTap: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    );
  }
}