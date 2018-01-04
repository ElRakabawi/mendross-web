<p align="center">
  <b>Main Links</b><br>
  <a href="https://github.com/elrakabawi/mendross" style="color: #AC00B1">Command-Line Interface Version</a> |
  <a href="https://elrakabawi.github.io/blog/2017/12/28/about-me/" style="color: #AC00B1">The author</a> |
  <a href="http://mendross.com/Mendross_Abstract.pdf" style="color: #AC00B1">Abstract</a>
  <br><br>
  <img src="http://mendross.com/logo.png">
</p>


# Mendross
[![Mendross](https://img.shields.io/website-up-down-green-red/http/shields.io.svg?label=Mendross.com)](http://mendross.com)
![](https://img.shields.io/badge/size-3.2%20MB-blue.svg)
[![Compatability test](https://img.shields.io/badge/responsivity-Good-Orange.svg)](http://www.responsinator.com/?url=www.mendross.com)

Mendross is a punnett square calculator with a chi-square functionality for solving Monohybrid, Dihybrid and Trihybrid mendelian genetic problems. 
<br/>
<br/>

## The story
I'm a biotechnological sciences student at MSA university. while taking a genetics course, I came to meet the basic mendelian inheritance punnett square. Oneday I encountered a problem solving a trihybrid crossing problem, I Googled a punnett square tool online but found nothing.
<br/>
<br/>

## So, What is this?
**Here's an glance of what mendross can do.**
<br/>
<br />
![](https://im3.ezgif.com/tmp/ezgif-3-f3b87a63fa.gif)

Simply, It's a tool developed for helping genetics students learn and experiment with Mendelian genetics laws, Through an Interactive, Free, Open-source and Easy-to-use Web App. There's another version of it as a [CLI](https://github.com/elrakabawi/mendross). The project is developed during the study year.

## Contributing

You can contribute to this project by either: 
1. Create an [issue](https://github.com/elrakabawi/mendross-web/issues)

Or:

1. Fork this repository
2. Clone the fork onto your system
3. Install [Perldancer](http://perldancer.org/) with `curl -L http://cpanmin.us | perl - --sudo Dancer2`
4. Run `plackup -r bin/app.psgi` to fire the server.
5. It's ready through [http://localhost:5000](http://localhost:5000)
5. Make changes and check for bugs :smile:
6. Submit a Pull Request referencing the issue 


## File Structure Outline

- `/views` contains the views with an extension (.tt) which is the Perldancer template engine translate.
- `/lib/Mendross.pm` contains the only controller written as a perl module, it contains all the logic behind mendross. 
- `/bin/app.psgi` is the perldancer server file
- `/public` contains CSS and JS static files (including Materials)
