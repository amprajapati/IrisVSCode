Class IrisVSCode.TestAPI Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/test" Method="GET" Call="HelloWorld" Cors="false" />
    </Routes>
}

ClassMethod HelloWorld() As %Status
{
        WRITE "Hello World"
        QUIT 1
}

}
