{
	/**
	 * # This New Programming Language
	 * 
	 * ## 1. Installation
	 * 
	 * ~$ `npm install -s this-new-programming-language`
	 * 
	 * ## 2. Usage
	 * 
	 * ...
	 * 
	 * ## 3. Conclusion
	 * 
	 * ...
	 * 
	 * 
	 * 
	 * 
	 */

	class IdManager {
		
		constructor() {
			this.id = 0;
		}

		getId() {
			return ++this.id;
		}

	}

	var idManager = new IdManager();

	class NodesMemoManager {
		constructor(idManager) {
			this.keys = {};
			this.idManager = idManager;
		}
		getOrSet(name, level, isNew=false) {
			console.log(`Looking for ${name}`);
			console.log(`Looking for ${name in this.keys}`);
			if(!isNew && name in this.keys) {
				console.log(`Found:`, this.keys[name]);
				var out = this.keys[name];
				return Object.assign({}, out, {type:"reference"}, {virtualLevel: level});
			} else {
				this.keys[name] = {
					id: this.idManager.getId(),
					shape: "box", 
					type:"node", 
					level, 
					label: name
				}; 
				console.log(`Created to:`, this.keys[name]);
				return this.keys[name];
			}
		}
	}

	var nodesMemoManager = new NodesMemoManager(idManager);

	class Utils {

		static decomposeFromArrays(item, acc=[]) {
			if(item instanceof Array) {
				for(var a=0; a<item.length; a++) {
					acc = Utils.decomposeFromArrays(item[a], acc);
				}
			} else typeof item !== "undefined" ? acc.push(item) : undefined;
			return acc;
		}

		static correctLevelOffset(item, levelReference) {
			console.log("ITTT", item, levelReference);
			for(var a=levelReference.length-1; a>=0; a--) {
				var levelInfo = levelReference[a];
				var {level, offset} = levelInfo;
				console.log("ILO", item, level, offset);
				if(level > item.level || level === 0) {
					return Object.assign({}, item, {level:level + item.level});
				} else {
					levelReference.pop();
				}
			}
		}

		static extendOptions(options) {
			return Object.assign({}, {
				physics: false,
				layout: {
					hierarchical: {
						enabled: true,
						nodeSpacing: 180,
						levelSeparation: 220,
						direction: "LR",
						sortMethod: "directed"
					}
				},
			}, options);
		}

		static getPreviousPointFromEdge(arr, indexEdge) {
			var original = arr[indexEdge];
			var origin = undefined;
			var items = arr.slice(0, indexEdge).reverse();
			console.log("original, origin, items", original, origin, items);
			ItemsIteration:
			for(var a=0; a < items.length; a++) {
				var item = items[a];
				console.log("Previous item from edge", item);
				if(item.level < (original.level -1)) {
					console.log("Iteration broken at", item);
					break ItemsIteration;
				} else if(item.level === (original.level-1)) {
					origin = item;
					break ItemsIteration;
				}
			}
			return origin;
		}
		static getNextPointsFromEdge(arr, indexEdge) {
			var original = arr[indexEdge];
			var others = [];
			var items = arr.slice(indexEdge);
			ItemsIteration:
			for(var a=1; a < items.length; a++) {
				var item = items[a];
				// console.log("Next item from edge", item);
				if(item.level <= original.level) {
					// console.log("Iteration broken at", item);
					break ItemsIteration;
				} else if((item.level === original.level) || (item.level === (original.level+1))) {
					others.push(item);
				}
			}
			return others;
		}
		static toVisParameters(data) {
			var nodes = [];
			var edges = [];
			var options = {};
			var levelReference = [
				{level:0,offset:0},
			];
			// //console.log("Alldata",data);
			for(var n=0; n<data.length; n++) {
				// //console.log("Row:", data[n]);
				var dataRow  = data[n].contents;
				for(var a=0; a<dataRow.length; a++) {
					var item = dataRow[a];
					console.log("Item:", item);
					switch(item.type) {
						case "edge":
						var origin = Utils.getPreviousPointFromEdge(dataRow, a);
						var others = Utils.getNextPointsFromEdge(dataRow, a);
						console.log("origin and others", a, dataRow, origin, others);
						for(var b=0; b<others.length; b++) {
							edges.push({
								from: origin.id,
								to: others[b].id,
								label: item.label,
								arrows: "to",
								font: {
									align: "middle"
								}
							});
						}
						break;
						case "node":
						nodes.push(/*Utils.correctLevelOffset(item, levelReference)*/item);
						var origin = Utils.getPreviousPointFromEdge(dataRow, a);
						if(origin) {
							edges.push({
								from: origin.id,
								to: item.id,
								arrows: "to",
								font: {
									align: "middle"
								}
							});
						}
						break;
						case "reference":
							console.log("Reference found", item);
							/*
							levelReference.push({
								level: item.virtualLevel,
								offset: item.level,
							});
							//*/
						break;
					}
				}
			}
			var output = Object.assign({}, {nodes, edges, options: Utils.extendOptions(options), data: data});
			console.log(output);
			return output;
		}
	}
}

Language = sentences:Sentences {return Utils.toVisParameters(sentences)}
Sentences = sentence_1:Sentence sentence_n:(New_line Sentence)* separation* {return [].concat(sentence_1).concat(sentence_n.map((i) => i[1]))}
Sentence = sentence:(Schema_sentence) {return sentence}
Schema_sentence = New_line? title:Schema_sentence_title contents:Schema_sentence_contents Schema_closer {return {title, contents, options}}
Schema_sentence_title = "# Schema - " [^\n]+ {return text().replace(/^# Schema - /g, "")}
Schema_closer = New_line "//" "/"+ [^\n]*
Schema_sentence_contents = nodes:Schema_sentence_node* {return nodes}
Schema_sentence_node = node:(Schema_sentence_node_edge / Schema_sentence_node_point) {return node;}
Schema_sentence_node_point = New_line level:Tabulation? new_instance:"*"? !("//") node:[^\n]+ {
	return nodesMemoManager.getOrSet(node.join(""), level ? level : 1, !!new_instance);
}
Schema_sentence_node_edge = New_line level:Tabulation "-" edge:[^\n]+ {
	return {
		type:"edge", 
		level: level, 
		label: edge.join("")
	};
}
Tabulation = " "+ {return text().length+1}
New_line =  ([\t\r ]* "\n")+
separation = [\n\r\t ]



