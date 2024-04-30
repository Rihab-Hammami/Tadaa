import 'package:flutter/material.dart';



class SearchWidget extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //Actions for the search bar (e.g., clear search query)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; //Clear the search query
        }, 
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon/button on the left side of the search bar (e.g., back button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        
        close(context, ''); // Close the search and return null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build the results based on the search query
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions that appear as the user types in the search bar
    final List<String> suggestions = []; // Example suggestions

    final List<String> filteredSuggestions = query.isEmpty
        ? suggestions // Show all suggestions if query is empty
        : suggestions.where((suggestion) => suggestion.contains(query)).toList(); // Filter suggestions based on the query

    return ListView.builder(
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        final String suggestion = filteredSuggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            // Perform action when suggestion is tapped (e.g., navigate to details page)
          },
        );
      },
    );
  }
}
