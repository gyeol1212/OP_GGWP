class HomeController < ApplicationController
  require 'open-uri'
  require 'json'
  def index
    url = 'https://kr.api.riotgames.com/lol/league/v3/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=RGAPI-4eae5fd2-874c-4ae0-8eb5-773b91f86151'
    @challenger = JSON.load(open(url))["entries"]
    a = 2
    b = 1
    c = 0 
    for i in 0..199
      if @challenger[i]["leaguePoints"] > a
        a = @challenger[i]["leaguePoints"]
        @challenger.insert(0,@challenger.delete_at(i))
      elsif @challenger[i]["leaguePoints"] <= a && @challenger[i]["leaguePoints"] > b
        b = @challenger[i]["leaguePoints"]
        @challenger.insert(1,@challenger.delete_at(i))
      elsif @challenger[i]["leaguePoints"] <= b && @challenger[i]["leaguePoints"] > c 
        c = @challenger[i]["leaguePoints"]
        @challenger.insert(2,@challenger.delete_at(i))
      end
    end
    @name1 = @challenger[0]["playerOrTeamName"]
    @name2 = @challenger[1]["playerOrTeamName"]
    @name3 = @challenger[2]["playerOrTeamName"]
    
  end
  
  def name1
    url = 'https://kr.api.riotgames.com/lol/league/v3/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=RGAPI-4eae5fd2-874c-4ae0-8eb5-773b91f86151'
    @challenger = JSON.load(open(url))["entries"]
    a = 0 
    for i in 0..199
      if @challenger[i]["leaguePoints"] > a
        a = @challenger[i]["leaguePoints"]
        @challenger.insert(0,@challenger.delete_at(i))
      end
    end

    @name1 = @challenger[0]["playerOrTeamName"]
    @wins = @challenger[0]["wins"]
    @losses = @challenger[0]["losses"]
    @winrate = @wins.to_f / (@wins + @losses).to_f * 100
    name1 = @name1.strip
    url = "https://kr.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{URI.encode(name1)}?api_key=RGAPI-4eae5fd2-874c-4ae0-8eb5-773b91f86151"
    @accountId = JSON.load(open(url))["accountId"]

    @Id = @accountId
    url = "https://kr.api.riotgames.com/lol/match/v3/matchlists/by-account/#{@Id}?api_key=RGAPI-4eae5fd2-874c-4ae0-8eb5-773b91f86151"
    @matchlists = JSON.load(open(url))["matches"]
    @play_champ = []
    @matchlists.each do |match|
      @play_champ.push(match["champion"])
    end
    @gameId_list =[]
    @matchlists.each do |match|
      @gameId_list.push(match["gameId"])
    end

    #매치리스트의 게임id 로 게임 불러오기 4개
    @game_part_list = []
    @champ_list = []
    @win_list = []
    @kda_list_all =[]
    @rate_list_all =[]
    for i in (0..4)
      url = "https://kr.api.riotgames.com/lol/match/v3/matches/#{@gameId_list[i]}?api_key=RGAPI-4eae5fd2-874c-4ae0-8eb5-773b91f86151"
      @game= JSON.load(open(url))

      if @game["teams"][0]["win"] == "Win"
        @win_list.push(1)
      else
        @win_list.push(2)
      end
      
      #참가자 이름 뽑아내기
      @game_participant = []
      @game["participantIdentities"].each do |part|
        @game_participant.push(part["player"]["summonerName"])
      end
      @game_part_list.push(@game_participant)
      
      #KDA 뽑아내기
      @kda_list =[]
      @rate_list = []
      @kda = @game["participants"].each do |part|
        @kda_list.push(part["stats"]["kills"].to_s + "/" + part["stats"]["deaths"].to_s + "/" + part["stats"]["assists"].to_s   )
        rate = ((part["stats"]["kills"].to_f + part["stats"]["assists"].to_f) / part["stats"]["deaths"].to_f).round(2)
        if part["stats"]["deaths"] == 0
          rate = "perfect"
        end
        @rate_list.push(rate)
      end
      @kda_list_all.push(@kda_list)
      @rate_list_all.push(@rate_list)

      #챔프 뽑아내기
      @champ = JSON.load(open(url))["participants"]
      @champs = []
      @champ.each do |cham|
        @champs.push(cham["championId"])
      end
      @champ_list.push(@champs)
    end
  
    url = "http://ddragon.leagueoflegends.com/cdn/6.24.1/data/ko_KR/champion.json"
    @championId = JSON.load(open(url))["data"].to_a
    @championId_list = {}
    for i in 0..133
      @championId_list[@championId[i][1]["key"]] = @championId[i][1]["name"]
    end
      @championId_list["498"] = "자야"
      @championId_list["497"] = "라칸"
      @championId_list["142"] = "조이"
      @championId_list["145"] = "카이사"

  
  end







  def name2
    url = 'https://kr.api.riotgames.com/lol/league/v3/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a'
    @challenger = JSON.load(open(url))["entries"]
    a = 0 
    b = 0
    for i in 0..199
      if @challenger[i]["leaguePoints"] > a
        a = @challenger[i]["leaguePoints"]
        @challenger.insert(0,@challenger.delete_at(i))
      elsif @challenger[i]["leaguePoints"] <= a && @challenger[i]["leaguePoints"] > b
        b = @challenger[i]["leaguePoints"]
        @challenger.insert(1,@challenger.delete_at(i))  
      end
    end
    @name2 = @challenger[1]["playerOrTeamName"]

    name2 = @name2.strip
    url = "https://kr.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{URI.encode(name2)}?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a"
    @accountId = JSON.load(open(url))["accountId"]

    @Id = @accountId
    url = "https://kr.api.riotgames.com/lol/match/v3/matchlists/by-account/#{@Id}?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a"
    @matchlists = JSON.load(open(url))["matches"]
    @gameId_list =[]
    @matchlists.each do |match|
      @gameId_list.push(match["gameId"])
    end

    #매치리스트의 게임id 로 게임 불러오기 4개
    @game_part_list = []
    for i in (0..4)
      url = "https://kr.api.riotgames.com/lol/match/v3/matches/#{@gameId_list[i]}?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a"
      @game= JSON.load(open(url))["participantIdentities"]
      @game_participant = []
      @game.each do |part|
        @game_participant.push(part["player"]["summonerName"])
      end
      @game_part_list.push(@game_participant)
    end
  end
  def name3
    url = 'https://kr.api.riotgames.com/lol/league/v3/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a'
    @challenger = JSON.load(open(url))["entries"]
    a = 2
    b = 1
    c = 0 
    for i in 0..199
      if @challenger[i]["leaguePoints"] > a
        a = @challenger[i]["leaguePoints"]
        @challenger.insert(0,@challenger.delete_at(i))
      elsif @challenger[i]["leaguePoints"] <= a && @challenger[i]["leaguePoints"] > b
        b = @challenger[i]["leaguePoints"]
        @challenger.insert(1,@challenger.delete_at(i))
      elsif @challenger[i]["leaguePoints"] <= b && @challenger[i]["leaguePoints"] > c 
        c = @challenger[i]["leaguePoints"]
        @challenger.insert(2,@challenger.delete_at(i))
      end
    end
    @name3 = @challenger[2]["playerOrTeamName"]

    name3 = @name3.strip
    url = "https://kr.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{URI.encode(name3)}?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a"
    @accountId = JSON.load(open(url))["accountId"]

    @Id = @accountId
    url = "https://kr.api.riotgames.com/lol/match/v3/matchlists/by-account/#{@Id}?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a"
    @matchlists = JSON.load(open(url))["matches"]
    @gameId_list =[]
    @matchlists.each do |match|
      @gameId_list.push(match["gameId"])
    end

    #매치리스트의 게임id 로 게임 불러오기 4개
    @game_part_list = []
    for i in (0..4)
      url = "https://kr.api.riotgames.com/lol/match/v3/matches/#{@gameId_list[i]}?api_key=RGAPI-822f56a0-5fb4-42d4-a074-d819ec7cef6a"
      @game= JSON.load(open(url))["participantIdentities"]
      @game_participant = []
      @game.each do |part|
        @game_participant.push(part["player"]["summonerName"])
      end
      @game_part_list.push(@game_participant)
    end
  end
 end
 