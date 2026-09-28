const fs=require('fs'),vm=require('vm'),assert=require('assert');
class File {
 constructor(path,mode){this.path=path;this.mode=mode;this.isopen=true;this.content=mode==='read'?fs.readFileSync(path,'utf8'):'';this.eof=this.content.length;}
 writestring(s){fs.writeFileSync(this.path,s);}
 readstring(n){return this.content.slice(0,n);}
 close(){this.isopen=false;}
}
const ctx={jsarguments:['aurora_ui.js','test'],box:{rect:[0,0,1120,750]},mgraphics:new Proxy({},{get:()=>()=>{}}),outlet:()=>{},post:console.log,arrayfromargs:a=>Array.from(a),File};
vm.createContext(ctx);vm.runInContext(fs.readFileSync('aurora_ui.js','utf8'),ctx);
ctx.preset(3);ctx.change(19,-22);ctx.savestatepath('tests/.state_io_test.json');
ctx.preset(1);ctx.change(19,-5);ctx.loadstatepath('tests/.state_io_test.json');
assert.equal(ctx.presetIndex,3);assert.equal(ctx.v.pitch,-7);assert.equal(ctx.v.gain,-22);assert.equal(ctx.v.reverse,.7);
console.log('State serializer and file round-trip: PASS');

fs.unlinkSync('tests/.state_io_test.json');
