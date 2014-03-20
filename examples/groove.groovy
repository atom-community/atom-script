def answer = 42
def gs = """Beer is $answer"""

def map = [gs:answer]
assert map["Beer is 42"] == null, "GString should not be used as a key"

map.put(gs.toString(), answer)
assert map["Beer is 42"] != null, "String should be used as a key"

println gs
