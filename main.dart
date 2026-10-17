import 'package:flutter/material.dart';
import 'chat.dart';
import 'login_screen.dart';

void main() {
  runApp(const ConnectApp());
}

/// Professional Theme Configurations
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF7F5F0),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFE7E5E0),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2563EB),
    secondary: Color(0xFF7C3AED),
    surface: Colors.white,
    onSurface: Color(0xFF1C1917),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFE7E5E0)),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFF0EDE8),
    disabledColor: const Color(0xFFE7E5E0),
    selectedColor: const Color(0xFF2563EB),
    secondarySelectedColor: const Color(0xFF2563EB),
    padding: EdgeInsets.zero,
    labelStyle: const TextStyle(fontSize: 11, color: Color(0xFF57534E)),
    secondaryLabelStyle: const TextStyle(fontSize: 11, color: Colors.white),
    brightness: Brightness.light,
    side: const BorderSide(color: Color(0xFFE7E5E0)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  ),
);

final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0C0A09),
  cardColor: const Color(0xFF1C1917),
  dividerColor: const Color(0xFF292524),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFFA78BFA),
    surface: Color(0xFF1C1917),
    onSurface: Color(0xFFFAFAF9),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1C1917),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFF292524)),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF292524),
    disabledColor: const Color(0xFF1C1917),
    selectedColor: const Color(0xFF3B82F6),
    secondarySelectedColor: const Color(0xFF3B82F6),
    padding: EdgeInsets.zero,
    labelStyle: const TextStyle(fontSize: 11, color: Color(0xFFA8A29E)),
    secondaryLabelStyle: const TextStyle(fontSize: 11, color: Colors.white),
    brightness: Brightness.dark,
    side: const BorderSide(color: Color(0xFF292524)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  ),
);

/// Root widget for the Connect App
class ConnectApp extends StatefulWidget {
  const ConnectApp({super.key});

  @override
  State<ConnectApp> createState() => _ConnectAppState();
}

class _ConnectAppState extends State<ConnectApp> {
  final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

  void _toggleTheme() {
    _themeNotifier.value =
        _themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Connect — Peer Study Groups',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          home: LoginScreen(
            isDarkMode: currentMode == ThemeMode.dark,
            onToggleTheme: _toggleTheme,
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// DATA MODELS
// -----------------------------------------------------------------------------

class StudyGroup {
  final String id;
  final String name;
  final String subject;
  final String department;
  final int maxMembers;
  final List<String> members;
  final String createdBy;
  final String sessionDate;
  final String expiryDate;
  final String location;
  final String whatsAppNumber;
  final String description;

  StudyGroup({
    required this.id,
    required this.name,
    required this.subject,
    required this.department,
    required this.maxMembers,
    required this.members,
    required this.createdBy,
    required this.sessionDate,
    required this.expiryDate,
    required this.location,
    required this.whatsAppNumber,
    required this.description,
  });
}

class JoinRequest {
  final String id;
  final String groupId;
  final String groupName;
  final String userName;
  final String userEmail;

  JoinRequest({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.userEmail,
  });
}

// -----------------------------------------------------------------------------
// MAIN DASHBOARD SCREEN (INDEX FRONTEND)
// -----------------------------------------------------------------------------

class IndexDashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const IndexDashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<IndexDashboardScreen> createState() => _IndexDashboardScreenState();
}

class _IndexDashboardScreenState extends State<IndexDashboardScreen> {
  // Current logged in user (Mock Frontend State)
  final String currentUser = "Alex Mercer";
  int _activeTab = 0; // 0: Browse, 1: Create, 2: My Groups, 3: Overview, 4: Admin
  String _searchQuery = "";
  String _selectedDepartment = "All";

  // Form Controllers
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _formDept = "Software Engineering";
  final int _formMaxMembers = 6;
  final DateTime? _formSessionDate = null;
  final DateTime? _formExpiryDate = null;

  // Departments List
  static const List<String> _departments = [
    "All",
    "Software Engineering",
    "Computer Science",
    "Electrical Engineering",
    "Business Administration",
    "Data Science",
    "Cybersecurity",
    "Other",
  ];

  // In-Memory Mock Study Groups
  late List<StudyGroup> _groups;
  late List<JoinRequest> _joinRequests;

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _locationController.dispose();
    _whatsappController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initMockData() {
    _groups = [
      StudyGroup(
        id: "g1",
        name: "HCI Final Exam Study Sprint",
        subject: "Human Computer Interaction",
        department: "Software Engineering",
        maxMembers: 6,
        members: ["Alex Mercer", "Sara Khan", "Bilal Ahmed"],
        createdBy: "Alex Mercer",
        sessionDate: "2026-10-15",
        expiryDate: "2026-10-14",
        location: "Central Library Room 3",
        whatsAppNumber: "03001234567",
        description: "Focusing on usability heuristics, design patterns, and exam past papers.",
      ),
      StudyGroup(
        id: "g2",
        name: "Data Structures Algorithms Practice",
        subject: "Data Structures & Algorithms",
        department: "Computer Science",
        maxMembers: 5,
        members: ["Zohaib Hassan", "Usman Ali"],
        createdBy: "Zohaib Hassan",
        sessionDate: "2026-10-18",
        expiryDate: "2026-10-17",
        location: "Discord Voice Channel",
        whatsAppNumber: "03129876543",
        description: "Solving LeetCode medium problems and trees/graphs dynamic programming.",
      ),
      StudyGroup(
        id: "g3",
        name: "Cybersecurity Lab Fundamentals",
        subject: "Network Security & Cryptography",
        department: "Cybersecurity",
        maxMembers: 4,
        members: ["Hamza Tariq", "Alex Mercer", "Ayesha Malik", "Zainab Shah"],
        createdBy: "Hamza Tariq",
        sessionDate: "2026-10-20",
        expiryDate: "2026-10-19",
        location: "CS Lab 2",
        whatsAppNumber: "03335551212",
        description: "Hands-on packet analysis with Wireshark and symmetric encryption tasks.",
      ),
    ];

    _joinRequests = [
      JoinRequest(
        id: "req1",
        groupId: "g1",
        groupName: "HCI Final Exam Study Sprint",
        userName: "Omer Farooq",
        userEmail: "omer@example.com",
      ),
    ];
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleJoinGroup(StudyGroup group) {
    setState(() {
      if (group.members.contains(currentUser)) {
        group.members.remove(currentUser);
        _showToast("Left group: ${group.name}");
      } else {
        if (group.members.length < group.maxMembers) {
          group.members.add(currentUser);
          _showToast("Joined group: ${group.name}");
        } else {
          _showToast("Group is already full!");
        }
      }
    });
  }

  void _createGroup() {
    if (_nameController.text.trim().isEmpty || _subjectController.text.trim().isEmpty) {
      _showToast("Please fill in required fields (Name & Subject)");
      return;
    }

    final newGroup = StudyGroup(
      id: "g_${DateTime.now().millisecondsSinceEpoch}",
      name: _nameController.text.trim(),
      subject: _subjectController.text.trim(),
      department: _formDept,
      maxMembers: _formMaxMembers,
      members: [currentUser],
      createdBy: currentUser,
      sessionDate: _formSessionDate != null
          ? "${_formSessionDate!.year}-${_formSessionDate!.month.toString().padLeft(2, '0')}-${_formSessionDate!.day.toString().padLeft(2, '0')}"
          : "TBD",
      expiryDate: _formExpiryDate != null
          ? "${_formExpiryDate!.year}-${_formExpiryDate!.month.toString().padLeft(2, '0')}-${_formExpiryDate!.day.toString().padLeft(2, '0')}"
          : "N/A",
      location: _locationController.text.trim().isEmpty ? "Online" : _locationController.text.trim(),
      whatsAppNumber: _whatsappController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    setState(() {
      _groups.insert(0, newGroup);
      _activeTab = 0; // Switch to Browse
    });

    _clearForm();
    _showToast("Study group created successfully!");
  }

  void _clearForm() {
    _nameController.clear();
    _subjectController.clear();
    _locationController.clear();
    _whatsappController.clear();
    _descriptionController.clear();
    setState(() {
      _formDept = "Software Engineering";
    });
  }

  void _deleteGroup(StudyGroup group) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete this group?"),
        content: const Text("This action cannot be undone. All members will lose access."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _groups.removeWhere((g) => g.id == group.id);
              });
              Navigator.pop(ctx);
              _showToast("Group deleted.");
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return AnimatedTheme(
      data: Theme.of(context),
      duration: const Duration(milliseconds: 200),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    _buildHeader(isDark),
                    const SizedBox(height: 16),

                    // USER BAR
                    _buildUserBar(isDark, bgCard, textColor),
                    const SizedBox(height: 20),

                    // CATEGORY NAVIGATION TABS
                    _buildCategoryNav(isDark),
                    const SizedBox(height: 24),

                    // ACTIVE TAB CONTENT
                    IndexedStack(
                      index: _activeTab,
                      children: [
                        _buildBrowseTab(isDark, bgCard, textColor),
                        _buildCreateTab(isDark, bgCard, textColor),
                        _buildMyGroupsTab(isDark, bgCard, textColor),
                        _buildOverviewTab(isDark, bgCard, textColor),
                        _buildAdminTab(isDark, bgCard, textColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
      (route) => false,
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER & USER BAR
  // ---------------------------------------------------------------------------

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: const [
                  TextSpan(text: "Connect"),
                  TextSpan(
                    text: ".",
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Find your study group — grow together",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Text(isDark ? "☀️" : "🌙", style: const TextStyle(fontSize: 20)),
              onPressed: widget.onToggleTheme,
              tooltip: "Toggle Theme",
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: _logout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserBar(bool isDark, Color bgCard, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1917) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF292524) : const Color(0xFF2563EB).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
            child: Text(
              currentUser.substring(0, 1),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Welcome, $currentUser",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildCategoryNav(bool isDark) {
    const categories = [
      {"icon": "🔍", "label": "Browse Groups", "desc": "Explore & join existing groups", "color": Color(0xFF2563EB)},
      {"icon": "✏️", "label": "Create Group", "desc": "Start your own study group", "color": Color(0xFF7C3AED)},
      {"icon": "📚", "label": "My Groups", "desc": "Groups created or joined", "color": Color(0xFF059669)},
      {"icon": "📊", "label": "Overview", "desc": "Stats & activity at a glance", "color": Color(0xFFD97706)},
      {"icon": "⚙️", "label": "Admin Panel", "desc": "Manage group join requests", "color": Color(0xFFDC2626)},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(categories.length, (index) {
        final cat = categories[index];
        final isActive = _activeTab == index;
        final color = cat["color"] as Color;

        return InkWell(
          onTap: () => setState(() => _activeTab = index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? color : (isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat["icon"] as String, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  cat["label"] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isActive ? color : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cat["desc"] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFFA8A29E) : Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: BROWSE GROUPS
  // ---------------------------------------------------------------------------

  Widget _buildBrowseTab(bool isDark, Color bgCard, Color textColor) {
    // Filter groups
    final filtered = _groups.where((g) {
      final matchesDept = _selectedDepartment == "All" || g.department == _selectedDepartment;
      final matchesSearch = _searchQuery.isEmpty ||
          g.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          g.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          g.department.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesDept && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        TextField(
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: "Search subject, topic or department...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: bgCard,
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFD6D3CE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Department Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _departments.map((dept) {
              final isSelected = _selectedDepartment == dept;
              return Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: ChoiceChip(
                  label: Text(dept, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : textColor)),
                  selected: isSelected,
                  selectedColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
                  backgroundColor: isDark ? const Color(0xFF1C1917) : const Color(0xFFFFFFFF),
                  side: BorderSide(
                    color: isSelected
                        ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB))
                        : (isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedDepartment = dept);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Groups list
        filtered.isEmpty
            ? _buildEmptyState("No study groups found matching your criteria.")
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildGroupCard(filtered[index], isDark, bgCard, textColor);
                },
              ),
      ],
    );
  }

  Widget _buildGroupCard(StudyGroup group, bool isDark, Color bgCard, Color textColor) {
    final isMember = group.members.contains(currentUser);
    final isCreator = group.createdBy == currentUser;
    final isFull = group.members.length >= group.maxMembers;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Department Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Subject: ${group.subject} • Created by ${group.createdBy}",
                        style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFA8A29E) : Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFF2563EB).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF3B82F6).withOpacity(0.3) : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    group.department,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Details
            Text(group.description, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),

            // Meta info
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _metaIconText(Icons.people, "${group.members.length}/${group.maxMembers} Members", isDark),
                _metaIconText(Icons.location_on_outlined, group.location, isDark),
                if (group.sessionDate.isNotEmpty) _metaIconText(Icons.event, "Session: ${group.sessionDate}", isDark),
                if (group.whatsAppNumber.isNotEmpty) _metaIconText(Icons.phone, group.whatsAppNumber, isDark),
              ],
            ),
            const SizedBox(height: 12),

            // Members chip list
            Wrap(
              spacing: 6,
              children: group.members.map((m) {
                final isYou = m == currentUser;
                return Chip(
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: isYou
                      ? (isDark ? const Color(0xFF1E3A5F) : const Color(0xFF2563EB).withOpacity(0.15))
                      : (isDark ? const Color(0xFF292524) : const Color(0xFFF0EDE8)),
                  side: BorderSide(
                    color: isYou
                        ? (isDark ? const Color(0xFF3B82F6).withOpacity(0.4) : const Color(0xFF2563EB).withOpacity(0.3))
                        : (isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
                  ),
                  label: Text(
                    isYou ? "$m (You)" : m,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isYou ? FontWeight.bold : FontWeight.normal,
                      color: isYou
                          ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                          : textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            Divider(height: 20, color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),

            // Action buttons
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(isMember ? Icons.exit_to_app : Icons.add_circle_outline, size: 16),
                  label: Text(isMember ? "Leave" : (isFull ? "Full" : "Join")),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMember ? Colors.orange : (isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB)),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isFull && !isMember ? null : () => _toggleJoinGroup(group),
                ),
                const SizedBox(width: 8),
                if (isMember)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text("Chat"),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFD6D3CE)),
                      foregroundColor: textColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            groupName: group.name,
                            groupSubject: group.subject,
                            groupId: group.id,
                            members: group.members,
                            currentUser: currentUser,
                            isDarkMode: isDark,
                            onToggleTheme: widget.onToggleTheme,
                          ),
                        ),
                      );
                    },
                  ),
                const Spacer(),
                if (isCreator)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteGroup(group),
                    tooltip: "Delete Group",
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaIconText(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: isDark ? const Color(0xFFA8A29E) : Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFA8A29E) : Colors.grey)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: CREATE GROUP
  // ---------------------------------------------------------------------------

  Widget _buildCreateTab(bool isDark, Color bgCard, Color textColor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a New Study Group",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Group Name *", hintText: "e.g. HCI Exam Prep"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: "Subject / Course *", hintText: "e.g. Human Computer Interaction"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _formDept,
              decoration: const InputDecoration(labelText: "Department"),
              dropdownColor: isDark ? const Color(0xFF1C1917) : Colors.white,
              items: _departments.where((d) => d != "All").map((d) {
                return DropdownMenuItem(value: d, child: Text(d));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _formDept = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location / Platform", hintText: "e.g. Library Room 3 / Google Meet"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "WhatsApp Contact Number", hintText: "03001234567"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "What will the group focus on? Prerequisites or goals...",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _createGroup,
                  child: const Text("Create Group"),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: _clearForm,
                  style: TextButton.styleFrom(
                    foregroundColor: isDark ? const Color(0xFFA8A29E) : Colors.grey[700],
                  ),
                  child: const Text("Clear Form"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: MY GROUPS
  // ---------------------------------------------------------------------------

  Widget _buildMyGroupsTab(bool isDark, Color bgCard, Color textColor) {
    final myGroups = _groups.where((g) => g.members.contains(currentUser)).toList();

    if (myGroups.isEmpty) {
      return _buildEmptyState("You haven't joined or created any study groups yet.");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: myGroups.length,
      itemBuilder: (context, index) {
        return _buildGroupCard(myGroups[index], isDark, bgCard, textColor);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: OVERVIEW / STATS
  // ---------------------------------------------------------------------------

  Widget _buildOverviewTab(bool isDark, Color bgCard, Color textColor) {
    final totalGroups = _groups.length;
    int totalMembers = 0;
    int openSpots = 0;

    for (var g in _groups) {
      totalMembers += g.members.length;
      openSpots += (g.maxMembers - g.members.length);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statCard("Total Groups", "$totalGroups", isDark ? const Color(0xFF93C5FD) : Colors.blue, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _statCard("Total Members", "$totalMembers", isDark ? const Color(0xFFA78BFA) : Colors.purple, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _statCard("Open Spots", "$openSpots", isDark ? const Color(0xFF86EFAC) : Colors.green, isDark)),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Department Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ..._departments.where((d) => d != "All").map((dept) {
                  final count = _groups.where((g) => g.department == dept).length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        SizedBox(width: 150, child: Text(dept, style: const TextStyle(fontSize: 12))),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: totalGroups > 0 ? count / totalGroups : 0,
                            backgroundColor: isDark ? const Color(0xFF292524) : Colors.grey.withOpacity(0.2),
                            color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text("$count", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFA8A29E) : Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 5: ADMIN PANEL
  // ---------------------------------------------------------------------------

  Widget _buildAdminTab(bool isDark, Color bgCard, Color textColor) {
    if (_joinRequests.isEmpty) {
      return _buildEmptyState("No pending join requests to manage.");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _joinRequests.length,
      itemBuilder: (context, index) {
        final req = _joinRequests[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0)),
          ),
          child: ListTile(
            title: Text("${req.userName} requested to join ${req.groupName}"),
            subtitle: Text("Email: ${req.userEmail}", style: TextStyle(color: isDark ? const Color(0xFFA8A29E) : Colors.grey[700])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      _joinRequests.removeAt(index);
                    });
                    _showToast("Request accepted!");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _joinRequests.removeAt(index);
                    });
                    _showToast("Request rejected.");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
