#!/bin/python

# MIT License
# 
# Copyright (c) 2019 Meyers Tom
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import sys
import dbus
import argparse
from shutil import which


parser = argparse.ArgumentParser()
parser.add_argument(
    '-t',
    '--trunclen',
    type=int,
    metavar='trunclen'
)
parser.add_argument(
    '-f',
    '--format',
    type=str,
    metavar='custom format',
    dest='custom_format'
)
parser.add_argument(
    '-p',
    '--playpause',
    type=str,
    metavar='play-pause indicator',
    dest='play_pause'
)
parser.add_argument(
    '--font',
    type=str,
    metavar='the index of the font to use for the main label',
    dest='font'
)
parser.add_argument(
    '--playpause-font',
    type=str,
    metavar='the index of the font to use to display the playpause indicator',
    dest='play_pause_font'
)


args = parser.parse_args()

def fix_string(string):
    # corrects encoding for the python version used
    if sys.version_info.major == 3:
        return string
    else:
        return string.encode('utf-8')

# Default parameters
output = fix_string(u'{play_pause} {artist}: {song}')
trunclen = 25
play_pause = fix_string(u'\u25B6,\u23F8') # first character is play, second is paused

label_with_font = '%{{T{font}}}{label}%{{T-}}'
font = args.font
play_pause_font = args.play_pause_font

# parameters can be overwritten by args
if args.trunclen is not None:
    trunclen = args.trunclen
if args.custom_format is not None:
    output = args.custom_format
if args.play_pause is not None:
    play_pause = args.play_pause

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        'org.mpris.MediaPlayer2.spotify',
        '/org/mpris/MediaPlayer2'
    )

    spotify_properties = dbus.Interface(
        spotify_bus,
        'org.freedesktop.DBus.Properties'
    )

    metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
    status = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

    # Handle play/pause label

    play_pause = play_pause.split(',')

    if status == 'Playing':
        play_pause = play_pause[0]
    elif status == 'Paused':
        play_pause = play_pause[1]
    else:
        play_pause = str()

    if play_pause_font:
        play_pause = label_with_font.format(font=play_pause_font, label=play_pause)

    # Handle main label

    artist = fix_string(metadata['xesam:artist'][0]) if metadata['xesam:artist'] else ''
    song = fix_string(metadata['xesam:title']) if metadata['xesam:title'] else ''

    if not artist and not song:
        print('')
    else:
        if len(song) > trunclen:
            song = song[0:trunclen]
            song += '...'
            if ('(' in song) and (')' not in song):
                song += ')'

        if font:
            artist = label_with_font.format(font=font, label=artist)
            song = label_with_font.format(font=font, label=song)

        print(output.format(artist=artist, song=song, play_pause=play_pause))

except Exception as e:
    if isinstance(e, dbus.exceptions.DBusException):
        print('')
    else:
        if which("spotify") is not None:
            print(e)
        else:
            print('')


