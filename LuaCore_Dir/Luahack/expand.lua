
function clipReplace(s) 
    -- grab the clipboard
    p = objc.class("NSPasteboard"):generalPasteboard()
    t = p:stringForType("NSStringPboardType")
    
    if t ~= nil then
        s = string.replace(s, "$clipboard$", t)
    end
    
    return s
end

success = false

lookup = {}

lookup['l']   = 'debug(@"<# #>");'
lookup['awa']   = '- (void) awakeFromNib {\n    <# #>\n}\n'
lookup['a']   = 'autorelease]'
lookup['ll']  = 'debug(@"%@", <#(NSString *)s#>);'
lookup['lll'] = 'debug(@"%s:%d", __FUNCTION__, __LINE__);'
lookup['lk']  = 'debug(@"$clipboard$: %@", $clipboard$);'
lookup['v']   = '- (void) <# #> {\n    <# #>\n}'
lookup['ib']  = '- (IBAction) <# #>:(id)sender {\n    <# #>\n}'
lookup['ff']  = '[NSString stringWithFormat:@"<# #>", <# #>]'
lookup['for'] = 'for (<# #> *<# #> in <# #>) {\n   <# #>\n}'
lookup['FM']  = 'FMRelease(<# #>);'
lookup['sele']  = '@selector(<# #>)'
lookup['fm']  = 'NSFileManager *fileManager = [NSFileManager defaultManager];'
lookup['ni']  = '= 0x00;'
lookup['enum']  = 'NSEnumerator *e = [<##> objectEnumerator];\n    <##>;\n\n    while ((<##> = [e nextObject])) {\n    	<#statements#>\n    }'
lookup['in']  = '@interface <#class#> (<#category#>)\n- (void)<#methodname#>;\n@end'

if lookup[selectedWord] ~= nil then
    textView:wipeCurrentWord()
    
    s = lookup[selectedWord]
    s = clipReplace(s)
    
    textView:insertText(s)
    
    if string.find(lookup[selectedWord], "<#") ~= nil then
        textView:XCcompletionPlaceholderSelect()
    end
    
    success = true
end
