# -*- coding: utf-8 -*- 

def stat_statistic(content,cmp_obj1,cmp_obj2,operation_times):
    """this function will used to calculate the total statistics record times and check if they are correct """
    
    import basic_class
    
    basic_class.mylogger_record.info('Analyzing the stat file ...')
    content = content.strip('\n')
    cmp_obj1 = cmp_obj1
    cmp_obj2 = cmp_obj2
    operation_times = operation_times # total attempts counts
    count_total = 0        # total operation attempts counts
    count_pass = 0         # passed operation attempts counts
    count_fail = 0         # failed operation attempts counts
    max_time_lists = []    # maximum
    result_lists = []      # will return thsi result at last
    
    if content.count(cmp_obj1) == content.count(cmp_obj2):
        result_lists.append('threshold success')
    else:
        result_lists.append('threshold fail')
    
    content_lists = content.split('\n')
    basic_class.mylogger_record.info('content_lists=')
    [basic_class.mylogger_recordnf.info(content_list) for content_list in content_lists]
    for list in content_lists:
        list = ('/'.join(list.split(' ')[-2:])).split('/')   # example : ['9', '9', '0', '403', '38', '54']
        count_total += int(list[0])
        count_pass += int(list[1])
        count_fail += int(list[2])
        max_time_lists.append(list[5])
    
    count_pass_fail = count_pass + count_fail
    basic_class.mylogger_record.debug('operation_times = '+str(operation_times))
    basic_class.mylogger_record.debug('count_total = '+str(count_total))
    basic_class.mylogger_record.debug('count_pass = '+str(count_pass))
    basic_class.mylogger_record.debug('count_fail = '+str(count_fail))
    basic_class.mylogger_record.debug('count_pass_fail = '+str(count_pass_fail))
    basic_class.mylogger_record.debug('max_time_lists = '+str(max_time_lists))
    
    if cmp_obj1 == '[0]':
        if count_pass == 0:
            if  operation_times == count_total and count_total == count_pass_fail:
                if count_fail > 0:
                    if int(max(max_time_lists)) > int(cmp_obj1.strip('[').strip(']')):
                        result_lists.append('count success')
                    else:
                        result_lists.append('count fail')
                else:
                    result_lists.append('count success')                                
            else:
                result_lists.append('count fail') 
        else:
            result_lists.append('count fail') 
    else:
        if  operation_times == count_total and count_total == count_pass_fail:    
            if count_fail > 0:                                                    
                if int(max(max_time_lists)) > int(cmp_obj1.strip('[').strip(']')):
                    result_lists.append('count success')                          
                else:                                                             
                    result_lists.append('count fail')                            
            else:                                                                 
                result_lists.append('count success')                                                                                                        
        else:    
            result_lists.append('count fail')                                                                  
    
    basic_class.mylogger_record.info('result_lists='+str(result_lists))
    return result_lists
        
    
    
    