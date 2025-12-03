import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pontaj_admin/l10n/app_localizations.dart';
import '../models/professor.dart';
import '../services/admin_service.dart';
import '../services/auth_service.dart';
import '../services/error_service.dart';
import '../utils/csv_downloader.dart';
import '../utils/apk_downloader.dart';
import '../widgets/language_switcher.dart';
import 'login_screen.dart';
import 'debug_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String token;
  final String username;

  const AdminDashboardScreen({
    super.key,
    required this.token,
    required this.username,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _adminService = AdminService();
  final _authService = AuthService();
  late Future<AdminListResponse> _adminsFuture;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  List<Professor> _currentAdmins = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshList();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshList();
    }
  }

  void _refreshList() {
    setState(() {
      _adminsFuture = _fetchAdmins();
    });
  }

  Future<AdminListResponse> _fetchAdmins() async {
    try {
      final response = await _adminService.getProfessors(widget.token);
      _currentAdmins = response.admins;
      return response;
    } catch (e) {
      if (e.toString().contains('401')) {
        // Token expired or invalid
        if (mounted) {
          _handleLogout();
        }
      }
      rethrow;
    }
  }

  void _downloadCsv() {
    final l10n = AppLocalizations.of(context)!;
    if (_currentAdmins.isEmpty) {
      ErrorService().showError(l10n.noDataToExport);
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('ID,Name,Email');
    for (var p in _currentAdmins) {
      buffer.writeln('${p.id},"${p.name}","${p.email}"');
    }

    downloadCsvFile(buffer.toString(), 'professors_stats.csv');
    ErrorService().showSuccess(l10n.statsExportedSuccess);
  }

  void _downloadApk() {
    downloadApk();
  }

  Future<void> _showProfessorDialog({Professor? professor}) async {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = professor != null;
    final nameController = TextEditingController(text: professor?.name ?? '');
    final emailController = TextEditingController(text: professor?.email ?? '');
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: animation,
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    isEditing ? l10n.editProfessor : l10n.addProfessor,
                  ),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: l10n.name,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.requiredField
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return l10n.emailRequired;
                            }
                            if (!value!.contains('@') || !value.contains('.')) {
                              return l10n.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: isEditing
                                ? l10n.newPassword
                                : l10n.password,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            helperText: l10n.passwordMinLength,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (!isEditing && (value?.isEmpty ?? true)) {
                              return l10n.passwordRequired;
                            }
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return l10n.passwordMinLength;
                            }
                            return null;
                          },
                        ),
                        if (isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                try {
                                  if (isEditing) {
                                    await _adminService.updateProfessor(
                                      widget.token,
                                      professor!.id,
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  } else {
                                    await _adminService.addProfessor(
                                      widget.token,
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  }
                                  if (mounted) {
                                    Navigator.pop(context);
                                    _refreshList();
                                  }
                                } catch (e) {
                                  // Error is already logged by ErrorService
                                } finally {
                                  if (mounted)
                                    setState(() => isLoading = false);
                                }
                              }
                            },
                      child: Text(isEditing ? l10n.save : l10n.add),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteProfessor(Professor professor) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteConfirmation(professor.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _adminService.deleteProfessor(widget.token, professor.id);
        _refreshList();
        // Success - refresh the list
      } catch (e) {
        // Error is already logged by ErrorService
      }
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Localize date format
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat('EEEE, d MMMM', l10n.localeName).format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS System Gray 6
      body: FutureBuilder<AdminListResponse>(
        future: _adminsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final data = snapshot.data;
          final admins = data?.admins ?? [];

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                backgroundColor: const Color(0xFFF2F2F7),
                surfaceTintColor: Colors.transparent,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text(
                    l10n.dashboard,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        bottom: 50,
                        child: Text(
                          dateStr.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                ),
                actions: [
                  // Language Switcher
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: LanguageSwitcher(),
                  ),
                  if (kIsWeb)
                    IconButton(
                      onPressed: _downloadApk,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.android,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                      tooltip: l10n.downloadApk,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.menu,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'debug':
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DebugScreen(),
                              ),
                            );
                            break;
                          case 'csv':
                            _downloadCsv();
                            break;
                          case 'logout':
                            _handleLogout();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'debug',
                          child: Row(
                            children: [
                              const Icon(Icons.bug_report, size: 20),
                              const SizedBox(width: 12),
                              Text(l10n.debugConsole),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'csv',
                          child: Row(
                            children: [
                              const Icon(Icons.download_rounded, size: 20),
                              const SizedBox(width: 12),
                              Text(l10n.downloadCsv),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.logout,
                                size: 20,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.logout,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildChartsSection(admins),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.professors,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.8),
                                letterSpacing: -0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ),
                              child: Text(
                                '${admins.length} ${l10n.total}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final admin = admins[index];
                      // First item gets top rounded corners, last gets bottom
                      final isFirst = index == 0;
                      final isLast = index == admins.length - 1;

                      return _AnimatedListItem(
                        index: index,
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 1,
                          ), // Separator line
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: isFirst
                                  ? const Radius.circular(20)
                                  : Radius.zero,
                              bottom: isLast
                                  ? const Radius.circular(20)
                                  : Radius.zero,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  admin.name.isNotEmpty
                                      ? admin.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              admin.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: -0.3,
                              ),
                            ),
                            subtitle: Text(
                              admin.email,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue[400],
                                    size: 22,
                                  ),
                                  onPressed: () =>
                                      _showProfessorDialog(professor: admin),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red[300],
                                    size: 22,
                                  ),
                                  onPressed: () => _deleteProfessor(admin),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: admins.length),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _showProfessorDialog(),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 4,
          highlightElevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(Icons.add),
          label: Text(
            l10n.addProfessor,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildChartsSection(List<Professor> admins) {
    final l10n = AppLocalizations.of(context)!;
    // Prepare data for Activity Overview (using IDs as proxy for timeline)
    // We'll take the last 10 admins to show recent "activity"
    final recentAdmins = admins.length > 10
        ? admins.sublist(admins.length - 10)
        : admins;

    final List<FlSpot> spots = [];
    for (int i = 0; i < recentAdmins.length; i++) {
      spots.add(FlSpot(i.toDouble(), recentAdmins[i].id.toDouble()));
    }

    // If no data, add some placeholders to avoid crash/empty chart
    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 0));
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            _buildChartCard(
              title: l10n.idGrowth,
              width: 400,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            'ID: ${spot.y.toInt()}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.4,
                      color: Theme.of(context).primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.3),
                            Theme.of(context).primaryColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            _buildChartCard(
              title: l10n.systemStatus,
              width: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          color: Theme.of(context).primaryColor,
                          value: 100,
                          showTitle: false,
                          radius: 15,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${admins.length}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        l10n.professors,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required Widget child,
    double width = 200,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AnimatedListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedListItem({required this.index, required this.child});

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(_animation);

    // Staggered animation
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
