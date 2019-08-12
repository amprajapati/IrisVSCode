Class IrisVSCode.TestAPI Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/test" Method="GET" Call="HelloWorld" Cors="true" />
<Route Url="/test1" Method="GET" Call="Test1" Cors="true" />
<Route Url="/tasks" Method="GET" Call="GetTasks" Cors="true" />
<Route Url="/tasks" Method="POST" Call="AddTask" Cors="true" />
<Route Url="/task/:id" Method="GET" Call ="GetTask" Cors="true" />
<Route Url="/task/:id" Method="PUT" Call ="UpdateTask" Cors="true" />
<Route Url="/task/:id" Method="DELETE" Call ="DeleteTask" Cors="true" />
</Routes>
}

ClassMethod HelloWorld() As %Status
{
    WRITE "Hello World"
    QUIT 1
}

ClassMethod Test1() As %Status
{
	SET obj = {
		"name": "Amit",
		"company": "test",
		"date": ($zdt($h,3,1)) 
	}
	WRITE obj.%ToJSON()
	
	QUIT 1
}

ClassMethod GetTasks() As %Status
{
	SET obj = {"tasks": [] }
	SET rs = ##class(%SQL.Statement).%ExecDirect(, "select id, text, important, completed FROM IrisVSCode.Task")
	
	WHILE rs.%Next() {
		SET task = {
			"id" : (rs.%Get("id")),
			"text" : (rs.%Get("text")),
			"important" : (rs.%Get("important")),
			"completed" : (rs.%Get("completed"))
		}
		
		DO obj.tasks.%Push(task)
	}
	
	WRITE obj.%ToJSON()
	QUIT 1
}

ClassMethod AddTask() As %Status
{
	SET obj = ##class(%DynamicObject).%FromJSON(%request.Content)
	SET task =  ##class(IrisVSCode.Task).%New()
	
	IF $length(obj.text) = 0 {
		SET %response.Status = "400 Bad Request"
		QUIT 1
	}
	
	SET task.text = obj.text
	SET task.important = obj.important
	SET task.completed = 0
	
	DO task.%Save()
	RETURN $$$OK
}

ClassMethod GetTask(id As %Integer) As %Status
{
	SET task = ##class(IrisVSCode.Task).%OpenId(id)
	
	IF '$IsObject(task) {
		SET %response.Status = "400 Bad Request"
		WRITE "Object is not available for requested id"
		QUIT 1
	}
	
	SET obj = {
			"id" : (task.%Id()),
			"text" : (task.text),
			"important" : (task.important),
			"completed" : (task.completed)
		}
	
	WRITE obj.%ToJSON()
	QUIT 1
}

ClassMethod UpdateTask(id As %Integer) As %Status
{
	SET obj = ##class(%DynamicObject).%FromJSON(%request.Content)
	SET task = ##class(IrisVSCode.Task).%OpenId(id)
	
	IF '$IsObject(task) {
		SET %response.Status = "400 Bad Request"
		WRITE "Object is not available for requested id"
		QUIT 1
	}
	
	IF obj.%IsDefined("text") {
		SET task.text = obj.text
	}
	
	IF obj.%IsDefined("important") {
		SET task.important = obj.important
	}
	
	IF obj.%IsDefined("completed") {
		SET task.completed = obj.completed
	}
	
	DO task.%Save()
	
	QUIT 1
}

ClassMethod DeleteTask() As %Status
{
	IF '##class(IrisVSCode.Task).%ExistsId(id) {
		SET %response.Status = "400 Bad Request"
		WRITE "Object is not available for requested id"
		QUIT 1
	}
	
	DO ##class(IrisVSCode.Task).%DeleteId(id)
	QUIT 1
}

ClassMethod IsError(pstatus As %String) As %Boolean
{
	IF $$$ISERR(pstatus)
	{
		WRITE !,"Error - "_$System.Status.GetErrorCodes(pstatus)
		QUIT 1
	}
}

}
