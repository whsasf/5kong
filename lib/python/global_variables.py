# -*- coding: utf-8 -*-

def _init():
    """initial a dict to store global veriables"""
    global _global_dict  #initialize
    _global_dict = {}


def import_variables_from_file(locations):
    """read given variable files from variable files under  etc path"""
    variable_files = locations # define a list contains the variable files
    for variable_file in variable_files:
        with open(variable_file) as file_object:
            lines = file_object.read().splitlines()
            for line in lines:
                if '=' in line:
                    _global_dict[line.split('=')[0].strip()] =  line.split('=')[1].strip()


def get_dict():
    """  read all variables in _global_dict currently  """
    print('==> The variables defined in etc files are:')
    for key ,value in _global_dict.items():
        print ('    '+key,':',value)
    print()
    print('==> Please attention,these variable names have alreaby been occupied!pleasae don\'t overwrite them!!')
    for key in _global_dict.keys():
        print('    '+key,end = ',')
    print('\n')
    
           
def set_value(key,value):
    """ define a global variable"""
    _global_dict[key] = value


def get_value(key,defValue=None):
    """ get a veriable ,retuen NONE if not exist """
    try:
        return _global_dict[key]
    except KeyError:
        return defValue
        
        
        
def get_values(*keys,defValue=None):
    """ get a variables ,retuen NONE if not exist """
    
    import basic_class
    tmp_vars = []
    basic_class.mylogger_record.debug('items in _global_dict are:')
    for key in keys:
        try:
            tmp_vars.append(_global_dict[key])
            basic_class.mylogger_recordnf.debug(key+' = '+_global_dict[key])
        except KeyError:
            tmp_vars.append(defValue)
    return tmp_vars
        
    