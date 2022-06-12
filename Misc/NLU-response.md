```jsgf
#JSGF V1.0 utf-8 en; 

grammar music_play; 

public <music_play> =  <initial> | <answer1> | <answer2> | <answer3>;

<initial> = [can you] (put on | play) (<artist> | <song>);
<answer1> = [i want to listen to] <genre> [music];
<answer2> = [play me] <album> [by] <artist>;
<answer3> = [put] <artist> [on];
<artist> = the beatles | radiohead | lady gaga | pink floyd; 
<song> = comfortably numb | paranoid android | let it be | hey jude;
<genre> = jazz | pop | classic;
<album> = ummagumma | other album;
```

```jsgf
#JSGF V1.0 utf-8 ko; 

grammar korean_music_play;

public <korean_music_play> =  <initial> | <answer1> | <answer2> | <answer3>;

<initial> = (<artist> | <song>) [을 | 를 | 좀] [틀어] [줘 | 줄 수 있어 | 봐];
<answer1> = <genre> [종류 | 류] [의 | 에] [음악] [을 | 들을 | 좀] [듣고 싶어 | 들려줘 | 틀어줘 | 틀어];
<answer2> = <artist> [의 | 에] <album> [틀어줘 | 틀어 | 들려줘];
<answer3> = <artist> [의 | 에] [노래] [아무거나] [틀어줘 | 틀어 | 들려줘];

<artist> = (the beatles | 비틀즈) | 
           (radiohead | 라디오헤드) | 
           (lady gaga | 레이디가가) | 
           (pink floyd | 핑크 플로이드); 

<song> = (comfortably numb | 컨포터블리 넘) | 
         (paranoid android | 파라노이드 안드로이드) | 
         (let it be | 렛잇비) | 
         (hey jude | 헤이 주드);

<genre> = (jazz | 재즈) | 
          (pop | 팝 | 팝송) | 
          (classic | 클래식);

<album> = ummagumma | 우마구마;
```

```
1. 비틀즈 좀 틀어줘
2. 재즈 류 음악 좀 듣고 싶어
3. 라이도헤드 의 렛잇비 틀어
4. 핑크 플로이드 노래 아무거나 틀어줘
```

```
There are simply too many possible ways to utter the same sentence. There could be myriad ways to compose the same sentence using different vocabulary or by rearranging tokens. Localizing the grammar into other languages also poses issues due to syntactic difference between languages. We could split each part into different references based on the parts of speech, so that we could construct the grammar with a particular focus on its fundamental structure rather than treating each sentence unique, for which its resolution would be to infinitely extend the grammar.
```

```
In Korean, there are intensive rules behind the proper usage of proposition and conjunction determined by their neighboring words. There also exists honorific form of utterances that can differentiate two sentences that conveys the same meaning. In the former case, we could create a reference for all propositions and conjunctions used in Korean language and include it as optional conditionals within the grammar. For the latter, we could create a grammar specific for those honorifics which generally occurs in a form of pronouns and closing phrases at the end of each sentence. For each grammar, we could then import this honorific grammar defined based on the parts of speech.
```