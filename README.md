Usage
====================

```ruby
require "string_expansion"

StringExpansion.apply("user[001-100]")
#=> ["user001", "user002", "user003", ... "user099", "user100"]

StringExpansion.apply("foo[01-10][a-b]")
#=> ["foo01a", "foo01b", "foo02a", "foo02b", ... "foo10a", "foo10b"]
```

