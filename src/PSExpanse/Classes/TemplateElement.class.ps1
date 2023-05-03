using namespace System.Collections.Generic

class TemplateElement { }

class TextElement : TemplateElement {
    [List[string]]$Content

    TextElement([List[string]]$content) {
        $this.Content = $content
    }
}

class FunctionElement : TemplateElement {
    [List[string]]$FunctionName
    [List[string[]]]$Arguments

    FunctionElement([List[string]]$functionName, [List[string[]]]$arguments) {
        $this.FunctionName = $functionName
        $this.Arguments = $arguments
    }
}

