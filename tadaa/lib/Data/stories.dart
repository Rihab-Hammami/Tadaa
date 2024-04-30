import 'package:flutter/material.dart';
import 'package:tadaa/models/story.dart';

final stories = [
  Story(
    mediaType: MediaType.image,
    url: 'https://i.pinimg.com/564x/9f/38/13/9f3813dd5ccd00ae41747a5f7b7a5322.jpg',
    caption: 'Check this out',
    date: '2 hours ago',
  ),
  Story(
    mediaType: MediaType.text,
    caption: 'What an amazing day it was...',
    date: 'Just now', 
    url: '',
  ),
  Story(
    mediaType: MediaType.image,
    url:
         'https://pbs.twimg.com/media/DRbnhBVWAAERQcr?format=jpg&name=900x900',
    caption: 'Totally Cool',
    date: '2 hours ago',
  ),
];