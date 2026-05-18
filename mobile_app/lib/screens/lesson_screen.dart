import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';
import 'package:smartino/screens/quiz_screen.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final Lesson lesson;

  const LessonScreen({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _currentSectionIndex = 0;
  bool _showCharacter = true;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a237e).withOpacity(0.8),
              Color(0xFF0d47a1).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ==================== HEADER ====================
              _buildHeader(),

              // ==================== PROGRESS BAR ====================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentSectionIndex + 1) /
                        widget.lesson.content.contentSections.length,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
              ),

              // ==================== CONTENT ====================
              Expanded(
                child: Stack(
                  children: [
                    // Lesson content
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentSectionIndex = index);
                      },
                      itemCount:
                          widget.lesson.content.contentSections.length + 1,
                      itemBuilder: (context, index) {
                        if (index ==
                            widget.lesson.content.contentSections.length) {
                          return _buildLessonSummary();
                        }
                        return _buildContentSection(index);
                      },
                    ),

                    // Character
                    if (_showCharacter)
                      Positioned(
                        right: 0,
                        bottom: 50,
                        child: _buildCharacter(),
                      ),
                  ],
                ),
              ),

              // ==================== CONTROLS ====================
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.lesson.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '${_currentSectionIndex + 1}/${widget.lesson.content.contentSections.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() => _showCharacter = !_showCharacter);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _showCharacter ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(int index) {
    final section = widget.lesson.content.contentSections[index];
    final title = section['title'] ?? 'Section ${index + 1}';
    final content = section['content'] ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 20),
          if (section['image_url'] != null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          SizedBox(height: 20),
          if (section['interactive'] != null)
            _buildInteractiveElement(section['interactive']),
        ],
      ),
    );
  }

  Widget _buildInteractiveElement(Map<String, dynamic> element) {
    final type = element['type'] ?? 'text';

    switch (type) {
      case 'question':
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '❓ Question: ${element['question']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: Text('Show Answer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );

      case 'exercise':
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✏️ Exercise: ${element['instruction']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: Text('Start Exercise'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildLessonSummary() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '🎉 Lesson Completed!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Takeaways:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                ...widget.lesson.content.learningObjectives.map((obj) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text('✓', style: TextStyle(color: Colors.green)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            obj,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to quiz
              },
              icon: Icon(Icons.quiz),
              label: Text('Take the Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter() {
    final character = widget.lesson.content.character;
    final phrases = character.encouragementPhrases.isNotEmpty
        ? character.encouragementPhrases
        : [character.greeting];

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              phrases[_currentSectionIndex % phrases.length],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.purple,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        alignment: Alignment.bottomRight,
        children: [
          // Speech bubble
          Container(
            margin: EdgeInsets.only(right: 16, bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                )
              ],
            ),
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              phrases[_currentSectionIndex % phrases.length],
              style: TextStyle(
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Character avatar
          Container(
            width: 120,
            height: 120,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '🤖',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final isLastSection =
        _currentSectionIndex == widget.lesson.content.contentSections.length;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentSectionIndex == 0
                  ? null
                  : () => _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
              icon: Icon(Icons.arrow_back),
              label: Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLastSection
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              QuizScreenPlaceholder(lesson: widget.lesson),
                        ),
                      );
                    }
                  : () => _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
              icon: Icon(isLastSection ? Icons.quiz : Icons.arrow_forward),
              label: Text(isLastSection ? 'Take Quiz' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastSection ? Colors.green : Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for quiz screen that will be implemented
class QuizScreenPlaceholder extends StatelessWidget {
  final Lesson lesson;

  const QuizScreenPlaceholder({Key? key, required this.lesson})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a237e).withOpacity(0.8),
              Color(0xFF0d47a1).withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Quiz coming soon!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Lesson'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
