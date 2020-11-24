# tmux helper


Take a look at the github reference for more details.
https://github.com/tmux/tmux/wiki/Getting-Started

https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/

## Create a tmux Session
```
tmux new -s SESSION_NAME
```

## Search Through History
```
Ctrl + r
```

## Command Prompt
```
Ctrl-b :
```

## List tmux Commands
```
tmux lsk -N|more
```


## Attaching and Detaching

### Detatch 
```
Ctrl-b d
```

### Attach
```
tmux attach
``` 
or 
```
tmux attach -t SESSION_NAME
```
	
## List sessions
```
tmux ls
```

## Creating new windows
```
Ctrl-b c
```

### Create new window and name it via tmux command line
```
Ctrl+b :
:neww -dn mynewwindow
```

## Splitting the window
https://github.com/tmux/tmux/wiki/Getting-Started#splitting-the-window

### Splitting Horizontally
```
Ctrl+b %
```
### Splitting Vertically
```
Ctrl+b "
```
## Changing Window
```
Ctrl+b INDEX_NUM
```

## Changing panes
### Listing Pane Numbers
```
Ctrl+b q
```
### Switching Panes
```
Ctrl+b q PANE_NUM
```
### Move to the next pane
```
Ctrl+b o
```

## Selecting a Session (Tree View)
Gives you a view of all windows within your current tmux session.
```
Ctrl-b w
```
When in tree view entering ```x``` can kill the session.

## Detaching/Entering Sessions from clients
Gives you a view of all tmux sessions.
```
Ctrl+b D
```

Key	Function
Enter	Detach selected client
d	Detach selected client, same as Enter
D	Detach tagged clients
x	Detach selected client and try to kill the shell it was started from
X	Detach tagged clients and try to kill the shells they were started from

## Killing Sessions
### Kill All Panes 
```
Ctrl+b &
```
### Kill Active Pane
```
Ctrl+b x
```

## Renaming a Session
```
Ctrl-b $
```

## Renaming a Window
```
Ctrl-b ,
```


## Swapping and Moving

to be cont.

