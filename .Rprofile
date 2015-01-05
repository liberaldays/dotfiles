if(interactive()){
  # Get startup messages of three packages and set Vim as R pager:
  options(setwidth.verbose = 1,
          colorout.verbose = 1,
          vimcom.verbose = 1,
          pager = "vimrpager")
  # Use the text based web browser w3m to navigate through R docs:
  if(Sys.getenv("TMUX") != "")
    options(browser="~/bin/vimrw3mbrowser",
            help_type = "html")
  # Use either Vim or GVim as text editor for R:
  if(nchar(Sys.getenv("DISPLAY")) > 1)
    options(editor = 'gvim -f -c "set ft=r"')
  else
    options(editor = 'vim -c "set ft=r"')
  # Load the colorout library:
  library(colorout)
  if(Sys.getenv("TERM") != "linux" && Sys.getenv("TERM") != ""){
    # Choose the colors for R output among 256 options.
    # You should run show256Colors() and help(setOutputColors256) to
    # know how to change the colors according to your taste:
    setOutputColors256(verbose = FALSE)
  }
  # Load the setwidth library:
  library(setwidth)
  # Load the vimcom.plus library only if R was started by Vim:
  if(Sys.getenv("VIMRPLUGIN_TMPDIR") != ""){
    library(vimcom)
    # If you can't install the vimcom.plus package, do:
    # library(vimcom)
    # See R documentation on Vim buffer even if asking for help in R Console:
    if(Sys.getenv("VIM_PANE") != "")
      options(help_type = "text", pager = "vimrpager")
  }
}

setHook(packageEvent("grDevices", "onLoad"),
  function(...){
        if(.Platform$OS.type == "windows")
            grDevices::windowsFonts(sans ="MS Gothic",
                                    serif="MS Mincho",
                                    mono ="FixedFont")
        if(capabilities("aqua"))
            grDevices::quartzFonts(
              sans =grDevices::quartzFont(
                c("Hiragino Kaku Gothic Pro W3",
                  "Hiragino Kaku Gothic Pro W6",
                  "Hiragino Kaku Gothic Pro W3",
                  "Hiragino Kaku Gothic Pro W6")),
              serif=grDevices::quartzFont(
                c("Hiragino Mincho Pro W3",
                  "Hiragino Mincho Pro W6",
                  "Hiragino Mincho Pro W3",
                  "Hiragino Mincho Pro W6")))
        if(capabilities("X11"))
            grDevices::X11.options(
                fonts=c("-kochi-gothic-%s-%s-*-*-%d-*-*-*-*-*-*-*",
                        "-adobe-symbol-medium-r-*-*-%d-*-*-*-*-*-*-*"))
        grDevices::pdf.options(family="Japan1GothicBBB")
        grDevices::ps.options(family="Japan1GothicBBB")
        }
)
attach(NULL, name = "JapanEnv")
assign("familyset_hook",
       function() {
            winfontdevs=c("windows","win.metafile",
                          "png","bmp","jpeg","tiff")
            macfontdevs=c("quartz","quartz_off_screen")
            devname=strsplit(names(dev.cur()),":")[[1L]][1]
            if ((.Platform$OS.type == "windows") &&
                (devname %in% winfontdevs))
                    par(family="sans")
            if (capabilities("aqua") &&
                devname %in% macfontdevs)
                    par(family="sans")
       },
       pos="JapanEnv")
setHook("plot.new", get("familyset_hook", pos="JapanEnv"))
setHook("persp", get("familyset_hook", pos="JapanEnv"))
options(repos="http://cran.ism.ac.jp/")
#options(error=function() traceback(2))
