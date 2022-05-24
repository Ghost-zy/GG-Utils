local zy={}

function zy.copy(src)
	if type(src)~="table" then
		return nil
	end
	local dest={}
	for k,v in pairs(src)do
		if type(v)=="table" then
			dest[k]=zy.copy(v)
		else
			dest[k]=v
		end
	end
	return dest
end

function zy.filter(items,value,key,reverse)
	if
		type(items)~="table"
	or
		type(value)==nil
	then
		return nil
	end

	if not key then
		key="value"
	end
	if not reverse then
		reverse=false
	end

	dest={}
	for i,v in ipairs(items)do
		if (v[key]==value)==(not reverse)then
			table.insert(dest,v)
		end
	end
	if#dest<=0 then
		return nil
	else
		return dest
	end
end

function zy.split(src,s)
	if
		type(src)~="string"
	or
		type(s)~="string"
	then
		return {}
	end
	local dest={}
	local index=nil
	while true do
		index=string.find(src,s)
		if not index then
			table.insert(dest,src)
			break
		end
		table.insert(dest,string.sub(src,1,index-1))
		index=index+string.len(s)
		if index>=#src then
			break
		end
		src=string.sub(src,index)
	end
	index=1
	while index<=#dest do
		if dest[index]==""then
			table.remove(dest,index)
		else
			index=index+1
		end
	end
	return dest
end

function zy.isResult(item)
	if
		type(item)~="table"
	or
		type(item.value)~="number"
	or
		type(item.flags)~="number"
	or
		type(item.address)~="number"
	then
		return false
	end
	return true
end

function zy.setElements(items,value,key,inc)
	if
		type(items)~="table"
	or
		value==nil
	then
		return
	end
	if not key then
		key="value"
	end
	if not inc then
		inc=false
	end

	for i,v in ipairs(items)do
		if type(value)=="number"and inc then
			v[key]=v[key]+value
		else
			v[key]=value
		end
	end
end

function zy.setValues(items,value,update)
	if
		type(items)~="table"
	or
		type(value)~="number"
	then
		return
	end
	zy.setElements(items,value)
	if update then
		gg.setValues(items)
	end
end

function zy.freeze(items,value,name)
	if type(items)~="table" then
		return
	end
	local flag_value=(type(value)=="number")
	local flag_name=(type(value)=="string")
	for i,v in ipairs(items)do
		v.freeze=true
		if flag_value then
			v.value=value
		end
		if flag_name then
			v.name=name
		end
	end
	gg.addListItems(items)
end

function zy.remove(items)
	if type(items)~="table" then
		return
	end
	gg.removeListItems(items)
end

function zy.getListItems(name)
	local items=gg.getListItems()
	if type(name)=="string" then
		return zy.filter(items,name,"name")
	end
end

function zy.search(count,...)
	gg.searchNumber(select(1,...)[1],select(1,...)[2])
	for i=2,select("#",...)do
		gg.refineNumber(select(i,...)[1],select(i,...)[2])
	end
	if count==0 then
		count=gg.getResultsCount()
	end
	count=gg.getResults(count)
	if #count<=0 then
		count=nil
	end
	return count
end

function zy.offset(item,offset)
	item=zy.copy(item)
	item.address=item.address+offset
	item=gg.getValues({item})[1]
	return item.value
end

function zy.findLast(str,flag)
	local index=string.find(str,flag)
	if not index then
		return nil
	end
	
	while true do
		local i=string.find(str,flag,index+1)
		if not i then
			return index
		else
			index=i
		end
	end
end

function zy.escape(raw)
	raw=string.gsub(raw,"%%","%%%%")
	raw=string.gsub(raw,"%(","%%(")
	raw=string.gsub(raw,"%)","%%)")
	raw=string.gsub(raw,"%.","%%.")
	raw=string.gsub(raw,"%+","%%+")
	raw=string.gsub(raw,"%-","%%-")
	raw=string.gsub(raw,"%?","%%?")
	raw=string.gsub(raw,"%^","%%^")
	raw=string.gsub(raw,"%$","%%$")
	--raw=string.gsub(raw,"%\*","%%\*")
	--raw=string.gsub(raw,"%\[","%%\[")
	return raw
end

function zy.getDir(file)
	if type(file)~="string"then
		file=gg.getFile()
	end
	return string.sub(file,1,zy.findLast(file,"/"))
end

function zy.getSegments(exp)
	local maps=gg.getRangesList(exp)
	local index=1
	while index<=#maps do
		if maps[index].type:sub(2,2)=="w"then
			index=index+1
		else
			table.remove(maps,index)
		end
	end
	return maps
end

function zy.gotoAddress(segment,...)
	local x64=gg.getTargetInfo().x64
	segment=zy.getSegments(segment)
	local i=
	{
		[true]=gg.TYPE_QWORD,
		[false]=gg.TYPE_DWORD
	}
	if#segment<=0 then
		return 0
	end
	segment=segment[1]
	segment=
	{
		address=segment.start,
		flags=i[x64]
	}
	i=1
	while i<select("#",...)do
		segment.address=segment.address+select(i,...)
		segment=gg.getValues({segment})[1]
		if segment.value==0 then
			return 0
		end
		if not x64 then
			segment.value=segment.value&0xFFFFFFFF
		end
		segment.address=segment.value
		i=i+1
	end
	return segment.value+select(i,...)
end

return zy