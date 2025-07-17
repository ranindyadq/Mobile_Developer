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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight,
        ), // Tinggi standar AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Latar belakang AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.1,
                ), // Warna bayangan (bisa disesuaikan)
                spreadRadius: 0, // Seberapa menyebar bayangan
                blurRadius: 4, // Seberapa buram bayangan
                offset: const Offset(0, 2), // Posisi bayangan (x, y)
              ),
            ],
          ),
          child: AppBar(
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
            backgroundColor: Colors
                .transparent, // AppBar harus transparan karena warna di Container
            elevation: 0, // Pastikan elevation di sini 0
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Consumer<UserDataProvider>(
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
                itemCount:
                    userData.users.length * 2 -
                    (userData.users.isEmpty ? 0 : 1) +
                    (userData.isLoading && userData.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Color.fromARGB(255, 228, 228, 228),
                    );
                  }
                  final userIndex = index ~/ 2;

                  if (userIndex < userData.users.length) {
                    final user = userData.users[userIndex];
                    return InkWell(
                      onTap: () {
                        Provider.of<AppStateProvider>(
                          context,
                          listen: false,
                        ).setSelectedUserName(
                          '${user.firstName} ${user.lastName}',
                        );
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(user.avatar),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xFF04021D),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Indikator loading di bagian paling bawah
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
