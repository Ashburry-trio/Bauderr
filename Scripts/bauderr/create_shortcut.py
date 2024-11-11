import os
from win32com.client import Dispatch
import os, sys

'''
:: : NOT FINISHED : ..
Create the shortcut name Bauderr-mirc.lnk (whatever $mircexe returns without the extension and path)
 inside $mircdir
get the target with $mircexe
get the -r Bauderr dir with $scriptdir..\..\..\ all the way to the root
get the work_dir $nofile($mircexe)

The mIRC script will have to direct the create_shortcut python script to the directory names
and its own filename of a Bauderr-client.lnk windows link.
You can create this link if it does not exist, or is recreated from the menubar popup. 
'''

class MG_createShortCut(object):
    def __init__(self, path: str, baud: str, target: str, icon: str):
        self.work_dir = os.path.abspath(os.join(target, '..'))
        shell = Dispatch('WScript.Shell')
        shortcut = shell.CreateShortCut(path)
        shortcut.Targetpath = '\"' + target + '\" -r' + '\"' + baud + '\"'
        shortcut.WorkingDirectory = self.work_dir
        shortcut.IconLocation = icon
        shortcut.save()

if __name__ == '__main__':
    print('this script is not meant to be run directly. use the MG script menu bar popup instead.')
    print('This script will create shortcuts on your desktop and in your mircdir -- which is the folder, where'
          'your mirc.ini file lives.')

