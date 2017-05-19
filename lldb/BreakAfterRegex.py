import lldb

def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('command script add -f BreakAfterRegex.breakAfterRegex bar')

def breakAfterRegex(debugger, command, result, internal_dict):
    target = debugger.GetSelectedTarget()
    breakpoint =target.BreakpointCreateByRegex(command)

    if not breakpoint.IsValid() or breakpoint.num_locations == 0:
        result.AppendWarning("Breakpoint isn't valid or hasn't found any hits")
    else:
        result.AppendMessage("{}").format(breakpoint)

    breakpoint.SetScriptCallbackFunction("BreakAfterRegex.breakpointHandler")


def breakpointHandler(frame, bp_loc, dict):
    function_name = frame.GetFunctionName()
    print("stopped in: {}".format(function_name))
    return true
