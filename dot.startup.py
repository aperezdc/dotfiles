import readline, atexit, os, rlcompleter
try:
    from importlib import reload
except:
    pass

historypath = os.path.expanduser("~/.pyhistory")
readline.parse_and_bind("tab: complete")

def save_history(historypath=historypath):
    import readline
    readline.write_history_file(historypath)

if os.path.exists(historypath):
    readline.read_history_file(historypath)

atexit.register(save_history)

del os, atexit, readline, save_history, historypath, rlcompleter
