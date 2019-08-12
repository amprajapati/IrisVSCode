Class IrisVSCode.Task Extends %Persistent
{

Property text As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 2 ];

Property important As %Library.Boolean [ SqlColumnNumber = 3 ];

Property completed As %Library.Boolean [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="TaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>text</Value>
</Value>
<Value name="3">
<Value>important</Value>
</Value>
<Value name="4">
<Value>completed</Value>
</Value>
</Data>
<DataLocation>^IrisVSCode.TaskD</DataLocation>
<DefaultData>TaskDefaultData</DefaultData>
<IdLocation>^IrisVSCode.TaskD</IdLocation>
<IndexLocation>^IrisVSCode.TaskI</IndexLocation>
<StreamLocation>^IrisVSCode.TaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
