It part of code for colorize sells by video frames.
At first, you need video (test.mp4). Create frames by <br>
`ffmpeg -i test.mp4 %d.jpg`
It create some screens in dir. <br>
Then, need to generate big json with data of all pixels color. Run `main.rb` and get data from `main_data.json`
Open `./plugin/helloworld.js` and change `data` to you code<br>
Then, add plugin do `CSE > 5.1.99.655 ` and run it in editor.
