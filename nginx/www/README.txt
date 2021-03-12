Backups are done accordingly

mkdir .backup/<yymmdd_HHMM>_<textnote>
cp -pr * .backup/<yymmdd_HHMM>_<textnote>/



Info about Framesets used in thses index files...

Framesets are not supported in HTML5, but they still work in most cases.
Please Note the following:

1. Each frame has it's own 'frame' tag.
2. Each frame has a name (eg, name="menu"). This is used for when you need to load one frame from another. For example, your left frame might have links that, when clicked on, loads a new page in the right frame. This is acheived by using 'target="content"' within your links/anchor tags.
3. Each 'frame' tag has a 'src' attribute. This is where you specify the name of the file to be loaded into that frame when the page first loads.
4. You can change the size of the frames by changing the value of the 'cols' and/or 'rows' attribute. A value of "200" sets the frame at 200 pixels. An asterisk (*) specifies that the frame should use up whatever space is left over from the other frames. You can also use percentage values if desired (i.e. 20%,80%)
5. To specify a border, set 'frameborder' and 'border' to "1". I included both attributes for maximum browser compatibility.
6. The 'framespacing' attribute doesn't work in all browsers, but you can set any numeric value you like here.
7. To learn more about HTML frames, check out: http://www.quackit.com/html/tutorial/html_frames.cfm.

