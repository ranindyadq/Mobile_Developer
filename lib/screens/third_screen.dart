import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/providers/user_data_provider.dart';
import 'package:application/providers/app_state_provider.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDataProvider>(context, listen: false).fetchInitialUsers();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<UserDataProvider>(context, listen: false).fetchUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Provider.of<UserDataProvider>(
      context,
      listen: false,
    ).fetchInitialUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Third Screen',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF04021D),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<UserDataProvider>(
        builder: (context, userData, child) {
          if (userData.isLoading && userData.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userData.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${userData.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        userData.fetchInitialUsers();
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (userData.users.isEmpty && !userData.isLoading) {
            return const Center(
              child: Text(
                'No user data.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: userData.users.length + (userData.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < userData.users.length) {
                  final user = userData.users[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                      onTap: () {
                        Provider.of<AppStateProvider>(
                          context,
                          listen: false,
                        ).setSelectedUserName(
                          '${user.firstName} ${user.lastName}',
                        );
                        Navigator.pop(context);
                      },
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
