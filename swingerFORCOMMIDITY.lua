local strategy = {}
local entrytime = 0
local exittime = 0 
local buytrig = 0
local selltrig = 0

local entrytime1 = 0
local exittime1 = 0  
local buytrig1 = 0
local selltrig1 = 0

local entrytime2 = 0
local exittime2 = 0  
local buytrig2 = 0
local selltrig2 = 0

local entrytime3 = 0
local exittime3 = 0  
local buytrig3 = 0
local selltrig3 = 0
local timePeriod = cs.h1
strategy.subscrib = {}
strategy.onStart = function(_self)
	strategy.subscrib={MT.getPara('merp'), MT.getPara('merp1'), MT.getPara('merp2'), MT.getPara('merp3')}	 
	_self.mafast, _self.maslow, _self.malong = MT.idcMA(MT.getPara('merp'), timePeriod, MT.getPara('fast'), MT.getPara('slow'), MT.getPara('long'))	
	_self.mafast1, _self.maslow1, _self.malong1 = MT.idcMA(MT.getPara('merp1'), timePeriod, MT.getPara('fast1'), MT.getPara('slow1'), MT.getPara('long1') )	
	_self.mafast2, _self.maslow2, _self.malong2 = MT.idcMA(MT.getPara('merp2'), timePeriod, MT.getPara('fast2'), MT.getPara('slow2'), MT.getPara('long2') )	
	_self.mafast3, _self.maslow3, _self.malong3 = MT.idcMA(MT.getPara('merp3'), timePeriod, MT.getPara('fast3'), MT.getPara('slow3'), MT.getPara('long3') )
end
strategy.onUpdate=function(_self)	    
	_self:onUpdate1()
    _self:onUpdate2()
    _self:onUpdate3()
	local merpcode = MT.getPara('merp')
	local count = MT.getPara('count')
    local k1 = MT.idcKLINE(merpcode,timePeriod,-1)
    local k2 = MT.idcKLINE(merpcode,timePeriod,-2)	 
    local price = MT.getLastPrice(merpcode)
	local pos = MT.tradePosition(merpcode)
    local mafast =  _self.mafast
    local maslow =  _self.maslow
	local malong = _self.malong
	local curtime = os.time()
    local stoploss = MT.getPara('stoploss') 
    local str2 = os.date('%H:%M:%S')
	local h11,m1,s1 = string.match(str2,"(%d+):(%d+):(%d+)")
    local time1 = h11 * 3600 + m1 * 60 + s1
	local priceosc = mafast[-2] - maslow[-2]
	local priceoscago = mafast[-3] - maslow[-3]
    local poslow = k2.l
	for i = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,i)
		if kfor.l < poslow then  
			poslow =  kfor.l
		end
	end
	local poshigh = k2.h
	for j = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,j)
		if kfor.h > poshigh then  
			poshigh =  kfor.h
		end
	end
	if pos[1] and pos then
	    for _,p in ipairs(pos) do
	        if p.num > 0 and price - p.price + stoploss < 0.00000001 and curtime - exittime > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime = curtime
				print('stoplossbuy') 	
	        end
	        if p.num > 0 and priceosc < priceoscago and price - poslow  < 0.00000001 and  curtime - exittime > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime = curtime
				print('buyorderexit') 	
	        end
			if p.num > 0 and k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime > 100   then
                MT.tradeMarketPriceSell(merpcode, 2*count)		
	            entrytime = curtime			 
	            print('duofankong')		
	        end	
	
			if p.num < 0 and  k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime > 100   then
                MT.tradeMarketPriceBuy(merpcode, 2 * count)		
	            entrytime = curtime			 
	            print('kongfanduo')		
	        end
	        if p.num < 0 and price - p.price - stoploss > 0.00000001 and curtime - exittime > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime = curtime
				print('stoplosssell') 	
	        end
		    if p.num < 0 and priceosc > priceoscago and price - poshigh  > 0.00000001 and  curtime - exittime > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime = curtime
				print('sellorderexit') 	
	        end		
		end	
	else
	    if k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime > 100   then
            MT.tradeMarketPriceBuy(merpcode, count)		
	        entrytime = curtime			 
	        print('buyentry')		
	    end
	    if k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime > 100   then
            MT.tradeMarketPriceSell(merpcode, count)		
	        entrytime = curtime			 
	        print('sellentry')		
	    end			
    end
end
strategy.onUpdate1=function(_self)	    
	local merpcode = MT.getPara('merp1')
	local count = MT.getPara('count')
    local k1 = MT.idcKLINE(merpcode,timePeriod,-1)
    local k2 = MT.idcKLINE(merpcode,timePeriod,-2)	 
    local price = MT.getLastPrice(merpcode)
	local pos = MT.tradePosition(merpcode)
    local mafast =  _self.mafast1
    local maslow =  _self.maslow1
	local malong = _self.malong1
	local curtime = os.time()
    local stoploss = MT.getPara('stoploss1') 
    local str2 = os.date('%H:%M:%S')
	local h11,m1,s1 = string.match(str2,"(%d+):(%d+):(%d+)")
    local time1 = h11 * 3600 + m1 * 60 + s1
	local priceosc = mafast[-2] - maslow[-2]
	local priceoscago = mafast[-3] - maslow[-3]
    local poslow = k2.l
	for i = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,i)
		if kfor.l < poslow then  
			poslow =  kfor.l
		end
	end
	local poshigh = k2.h
	for j = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,j)
		if kfor.h > poshigh then  
			poshigh =  kfor.h
		end
	end
	if pos[1] and pos then
	    for _,p in ipairs(pos) do
	        if p.num > 0 and price - p.price + stoploss < 0.00000001 and curtime - exittime1 > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime1 = curtime
				print('stoplossbuy1') 	
	        end
	        if p.num > 0 and priceosc < priceoscago and price - poslow  < 0.00000001 and  curtime - exittime1 > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime1 = curtime
				print('buyorderexit1') 	
	        end
			if p.num > 0 and k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime1 > 100   then
                MT.tradeMarketPriceSell(merpcode, 2*count)		
	            entrytime1 = curtime			 
	            print('duofankong1')		
	        end	
	
			if p.num < 0 and  k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime1 > 100   then
                MT.tradeMarketPriceBuy(merpcode, 2 * count)		
	            entrytime1 = curtime			 
	            print('kongfanduo1')		
	        end
	        if p.num < 0 and price - p.price - stoploss > 0.00000001 and curtime - exittime1 > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime1 = curtime
				print('stoplosssell1') 	
	        end
		    if p.num < 0 and priceosc > priceoscago and price - poshigh  > 0.00000001 and  curtime - exittime1 > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime1 = curtime
				print('sellorderexit1') 	
	        end		
		end	
	else
	    if k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime1 > 100   then
            MT.tradeMarketPriceBuy(merpcode, count)		
	        entrytime1 = curtime			 
	        print('buyentry1')		
	    end
	    if k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime1 > 100   then
            MT.tradeMarketPriceSell(merpcode, count)		
	        entrytime1 = curtime			 
	        print('sellentry1')		
	    end			
    end
end
strategy.onUpdate2=function(_self)	    
	local merpcode = MT.getPara('merp2')
	local count = MT.getPara('count')
    local k1 = MT.idcKLINE(merpcode,timePeriod,-1)
    local k2 = MT.idcKLINE(merpcode,timePeriod,-2)	 
    local price = MT.getLastPrice(merpcode)
	local pos = MT.tradePosition(merpcode)
    local mafast =  _self.mafast2
    local maslow =  _self.maslow2
	local malong = _self.malong2
	local curtime = os.time()
    local stoploss = MT.getPara('stoploss2') 
    local str2 = os.date('%H:%M:%S')
	local h11,m1,s1 = string.match(str2,"(%d+):(%d+):(%d+)")
    local time1 = h11 * 3600 + m1 * 60 + s1
	local priceosc = mafast[-2] - maslow[-2]
	local priceoscago = mafast[-3] - maslow[-3]
    local poslow = k2.l
	for i = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,i)
		if kfor.l < poslow then  
			poslow =  kfor.l
		end
	end
	local poshigh = k2.h
	for j = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,j)
		if kfor.h > poshigh then  
			poshigh =  kfor.h
		end
	end
	if pos[1] and pos then
	    for _,p in ipairs(pos) do
	        if p.num > 0 and price - p.price + stoploss < 0.00000001 and curtime - exittime2 > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime2 = curtime
				print('stoplossbuy2') 	
	        end
	        if p.num > 0 and priceosc < priceoscago and price - poslow  < 0.00000001 and  curtime - exittime2 > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime2 = curtime
				print('buyorderexit2') 	
	        end
			if p.num > 0 and k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime2 > 100   then
                MT.tradeMarketPriceSell(merpcode, 2*count)		
	            entrytime2 = curtime			 
	            print('duofankong2')		
	        end	
	
			if p.num < 0 and  k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime2 > 100   then
                MT.tradeMarketPriceBuy(merpcode, 2 * count)		
	            entrytime2 = curtime			 
	            print('kongfanduo2')		
	        end
	        if p.num < 0 and price - p.price - stoploss > 0.00000001 and curtime - exittime2 > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime2 = curtime
				print('stoplosssell2') 	
	        end
		    if p.num < 0 and priceosc > priceoscago and price - poshigh  > 0.00000001 and  curtime - exittime2 > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime2 = curtime
				print('sellorderexit2') 	
	        end		
		end	
	else
	    if k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime2 > 100   then
            MT.tradeMarketPriceBuy(merpcode, count)		
	        entrytime2 = curtime			 
	        print('buyentry2')		
	    end
	    if k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime2 > 100   then
            MT.tradeMarketPriceSell(merpcode, count)		
	        entrytime2 = curtime			 
	        print('sellentry2')		
	    end			
    end
end
strategy.onUpdate3=function(_self)	    
	local merpcode = MT.getPara('merp3')
	local count = MT.getPara('count')
    local k1 = MT.idcKLINE(merpcode,timePeriod,-1)
    local k2 = MT.idcKLINE(merpcode,timePeriod,-2)	 
    local price = MT.getLastPrice(merpcode)
	local pos = MT.tradePosition(merpcode)
    local mafast =  _self.mafast3
    local maslow =  _self.maslow3
	local malong = _self.malong3
	local curtime = os.time()
    local stoploss = MT.getPara('stoploss3') 
    local str2 = os.date('%H:%M:%S')
	local h11,m1,s1 = string.match(str2,"(%d+):(%d+):(%d+)")
    local time1 = h11 * 3600 + m1 * 60 + s1
	local priceosc = mafast[-2] - maslow[-2]
	local priceoscago = mafast[-3] - maslow[-3]
    local poslow = k2.l
	for i = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,i)
		if kfor.l < poslow then  
			poslow =  kfor.l
		end
	end
	local poshigh = k2.h
	for j = -4,-2,1 do  
		local kfor = MT.idcKLINE(merpcode,timePeriod,j)
		if kfor.h > poshigh then  
			poshigh =  kfor.h
		end
	end
	if pos[1] and pos then
	    for _,p in ipairs(pos) do
	        if p.num > 0 and price - p.price + stoploss < 0.00000001 and curtime - exittime3 > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime3 = curtime
				print('stoplossbuy3') 	
	        end
	        if p.num > 0 and priceosc < priceoscago and price - poslow  < 0.00000001 and  curtime - exittime3 > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime3 = curtime
				print('buyorderexit3') 	
	        end
			if p.num > 0 and k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime3 > 100   then
                MT.tradeMarketPriceSell(merpcode, 2*count)		
	            entrytime3 = curtime			 
	            print('duofankong3')		
	        end	
	
			if p.num < 0 and  k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime3 > 100   then
                MT.tradeMarketPriceBuy(merpcode, 2 * count)		
	            entrytime3 = curtime			 
	            print('kongfanduo3')		
	        end
	        if p.num < 0 and price - p.price - stoploss > 0.00000001 and curtime - exittime3 > 100 then     
	            MT.tradeClosedPosition(p.id)
				exittime3 = curtime
				print('stoplosssell3') 	
	        end
		    if p.num < 0 and priceosc > priceoscago and price - poshigh  > 0.00000001 and  curtime - exittime3 > 100 then  
	            MT.tradeClosedPosition(p.id)
				exittime3 = curtime
				print('sellorderexit3') 	
	        end		
		end	
	else
	    if k2.c > malong[-2]  and priceosc > priceoscago and  priceosc < 0 and curtime - entrytime3 > 100   then
            MT.tradeMarketPriceBuy(merpcode, count)		
	        entrytime3 = curtime			 
	        print('buyentry3')		
	    end
	    if k2.c < malong[-2]  and priceosc < priceoscago and  priceosc > 0 and curtime - entrytime3 > 100   then
            MT.tradeMarketPriceSell(merpcode, count)		
	        entrytime3 = curtime			 
	        print('sellentry3')		
	    end			
    end
end
strategy.paras={count={2,'手数设置0'},merp={'gcz7','选择商品0'},fast = {9,'fastma'}, slow = {27,'slowma'},long = {50,'slowma'},stoploss = {8,'stoploss'},merp1={'6BU7','选择商品1'},fast1 = {9,'fastma'}, slow1 = {27,'slowma'},long1 = {50,'slowma'},stoploss1 = {0.008,'stoploss'},
merp2={'6EU7','选择商品2'},fast2 = {9,'fastma'}, slow2 = {27,'slowma'},long2 = {50,'slowma'},stoploss2 = {0.004,'stoploss'},merp3={'6JU7','选择商品3'},fast3 = {9,'fastma'}, slow3 = {27,'slowma'},long3 = {50,'slowma'},stoploss3 = {0.000045,'stoploss'}}	
MT.registerStrategy(strategy)