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