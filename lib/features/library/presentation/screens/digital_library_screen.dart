import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/library_folder.dart';
import '../../../../core/models/media_resource.dart';
import '../../../../core/services/library_provider.dart';
import '../../../../core/services/download_provider.dart';
import '../../../../core/services/favorites_provider.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import 'pdf_viewer_screen.dart';
import 'audio_player_screen.dart';
import 'question_papers_screen.dart';

class DigitalLibraryScreen extends StatefulWidget {
  const DigitalLibraryScreen({super.key});

  @override
  State<DigitalLibraryScreen> createState() => _DigitalLibraryScreenState();
}

class _DigitalLibraryScreenState extends State<DigitalLibraryScreen> {
  String? _currentFolderId;
  final List<LibraryFolder> _navigationHistory = [];
  
  bool _isGridView = true;
  String _searchQuery = '';
  String _selectedFilter = 'Newest';

  void _onFolderTap(LibraryFolder folder) {
    setState(() {
      _navigationHistory.add(folder);
      _currentFolderId = folder.id;
    });
  }

  void _onBreadcrumbTap(int index) {
    setState(() {
      if (index == -1) {
        _currentFolderId = null;
        _navigationHistory.clear();
      } else {
        _currentFolderId = _navigationHistory[index].id;
        _navigationHistory.removeRange(index + 1, _navigationHistory.length);
      }
    });
  }

  void _onCreateFolder(String userClass, String subject) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Folder'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Folder Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Provider.of<LibraryProvider>(context, listen: false).createFolder(
                  name: nameController.text.trim(),
                  colorValue: 0xFF1E3C72,
                  iconCodePoint: 0xe241,
                  parentFolderId: _currentFolderId,
                  userClass: userClass,
                  subject: subject,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _onRenameFolder(String id, String currentName) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'New Folder Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Provider.of<LibraryProvider>(context, listen: false).renameFolder(
                  id,
                  nameController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _onOpenResource(MediaResource resource) {
    if (resource.mediaType == 'pdf' || resource.mediaType == 'sheet') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerScreen(resource: resource)),
      );
    } else if (resource.mediaType == 'audio') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AudioPlayerScreen(resource: resource)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening ${resource.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthViewModel>(context).userProfile;
    final libProvider = Provider.of<LibraryProvider>(context);
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);
    
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final userClass = user.userClass.isNotEmpty ? user.userClass : 'Class 5';
    final userSubject = 'Mathematics'; // default class subject folders

    // Fetch folders and resources in current level
    List<LibraryFolder> currentFolders = libProvider.getFoldersInParent(_currentFolderId, userClass, userSubject);
    List<MediaResource> currentResources = libProvider.getResourcesInFolder(_currentFolderId, userClass, userSubject);

    // Apply Search Filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      currentFolders = currentFolders.where((f) => f.name.toLowerCase().contains(q)).toList();
      currentResources = currentResources.where((r) => r.title.toLowerCase().contains(q) || r.chapter.toLowerCase().contains(q)).toList();
    }

    // Apply Sorting Filter
    if (_selectedFilter == 'Oldest') {
      currentResources.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    } else if (_selectedFilter == 'Newest') {
      currentResources.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    } else if (_selectedFilter == 'Favourite') {
      currentResources = currentResources.where((r) => favProvider.isFavorite(r.id, r.mediaType)).toList();
    } else if (_selectedFilter == 'Downloaded') {
      currentResources = currentResources.where((r) => downloadProvider.isDownloaded(r.fileUrl)).toList();
    }

    final isStaff = user.role == 'Teacher' || user.role == 'Admin' || user.role == 'Super Admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Library Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Question Papers Archive',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuestionPapersScreen(userClass: userClass)),
              );
            },
          ),
          if (isStaff)
            IconButton(
              icon: const Icon(Icons.create_new_folder_outlined),
              tooltip: 'Create New Folder',
              onPressed: () => _onCreateFolder(userClass, userSubject),
            ),
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Panel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: 'Search folders, notes, e-books...',
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryBlue),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedFilter,
                  icon: const Icon(Icons.filter_list, color: AppColors.primaryBlue),
                  underline: const SizedBox.shrink(),
                  items: ['Newest', 'Oldest', 'Downloaded', 'Favourite'].map((f) {
                    return DropdownMenuItem(value: f, child: Text(f));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedFilter = val);
                    }
                  },
                )
              ],
            ),
          ),
          
          // Breadcrumb Navigation bar
          _buildBreadcrumbs(isDark),
          
          Expanded(
            child: (currentFolders.isEmpty && currentResources.isEmpty)
                ? _buildEmptyState()
                : _isGridView
                    ? _buildGridView(currentFolders, currentResources, downloadProvider, favProvider, isStaff, isDark)
                    : _buildListView(currentFolders, currentResources, downloadProvider, favProvider, isStaff, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs(bool isDark) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      color: isDark ? AppColors.darkSurface : Colors.grey[100],
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () => _onBreadcrumbTap(-1),
            child: const Center(
              child: Text(
                'Root Library',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 13),
              ),
            ),
          ),
          ...List.generate(_navigationHistory.length, (index) {
            final f = _navigationHistory[index];
            return Row(
              children: [
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                InkWell(
                  onTap: () => _onBreadcrumbTap(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      f.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 13),
                    ),
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildGridView(
    List<LibraryFolder> folders,
    List<MediaResource> resources,
    DownloadProvider dlProvider,
    FavoritesProvider favProvider,
    bool isStaff,
    bool isDark,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: folders.length + resources.length,
      itemBuilder: (context, index) {
        if (index < folders.length) {
          final folder = folders[index];
          return _buildFolderGridCard(folder, isStaff, isDark);
        } else {
          final resource = resources[index - folders.length];
          return _buildResourceGridCard(resource, dlProvider, favProvider, isDark);
        }
      },
    );
  }

  Widget _buildFolderGridCard(LibraryFolder folder, bool isStaff, bool isDark) {
    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      child: InkWell(
        onTap: () => _onFolderTap(folder),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(folder.colorValue).withOpacity(0.12),
                    child: Icon(IconData(folder.iconCodePoint, fontFamily: 'MaterialIcons'), color: Color(folder.colorValue), size: 20),
                  ),
                  if (isStaff)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'rename', child: Text('Rename')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                      onSelected: (val) {
                        if (val == 'rename') {
                          _onRenameFolder(folder.id, folder.name);
                        } else if (val == 'delete') {
                          Provider.of<LibraryProvider>(context, listen: false).deleteFolder(folder.id);
                        }
                      },
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folder.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const Text('Folder System', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceGridCard(MediaResource res, DownloadProvider dl, FavoritesProvider fav, bool isDark) {
    final bool isFav = fav.isFavorite(res.id, res.mediaType);
    final bool isDownloaded = dl.isDownloaded(res.fileUrl);

    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      child: InkWell(
        onTap: () => _onOpenResource(res),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: res.mediaType == 'pdf' ? Colors.red.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      res.mediaType == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file,
                      color: res.mediaType == 'pdf' ? Colors.red : AppColors.primaryBlue,
                      size: 18,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey, size: 18),
                        onPressed: () => fav.toggleFavorite(res.id, res.mediaType),
                      ),
                      if (!isDownloaded && res.fileUrl.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.download, size: 18, color: AppColors.primaryBlue),
                          onPressed: () {
                            dl.startDownload(res.id, res.title, res.fileUrl, res.mediaType);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading file offline...')));
                          },
                        ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    res.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    res.mediaType.toUpperCase(),
                    style: TextStyle(
                      color: isDownloaded ? AppColors.accentGreen : Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
    List<LibraryFolder> folders,
    List<MediaResource> resources,
    DownloadProvider dlProvider,
    FavoritesProvider favProvider,
    bool isStaff,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...folders.map((f) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.folder, color: Color(f.colorValue)),
                title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Folder'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _onFolderTap(f),
              ),
            )),
        ...resources.map((r) {
          final isDownloaded = dlProvider.isDownloaded(r.fileUrl);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(r.mediaType == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file, color: Colors.grey),
              title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(isDownloaded ? 'Downloaded Offline' : r.sizeInfo),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _onOpenResource(r),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('This folder is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }
}
