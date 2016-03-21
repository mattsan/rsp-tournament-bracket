require 'haml'

POWER2 = 10.times.map {|i| 2 ** i }

def to_svg(input, expected)
  svg = []
  players = input.scan(/\([RSP]+\)/)
  players_count = players.size
  level = Math.log2(players.size).ceil
  y = level * 20 + 40

  points = (players_count.times.map {|i| i * 20 + 10 }).zip([y] * players_count)
  players.zip(points).each do |player, (x, y)|
    svg.push "  %text{x: 0, y: 0, 'font-family' => 'Arial', 'font-size' => 8, fill: 'black', 'text-anchor' => 'end', transform: 'rotate(-90,#{x},#{y})'} #{player}"
  end

  if ! POWER2.include?(players_count)
    y -= 20
    seeded_count = (2 ** level - players_count)
    points.drop(seeded_count).each_slice(2) do |(x1, y1), (x2, y2)|
      svg.push "  %path{d: 'M #{x1} #{y1} L #{x1} #{y}', stroke: 'black', fill: 'none'}"
      svg.push "  %path{d: 'M #{x2} #{y2} L #{x2} #{y}', stroke: 'black', fill: 'none'}"
      svg.push "  %path{d: 'M #{x1} #{y} L #{x2} #{y}', stroke: 'black', fill: 'none'}"
    end

    points = points.take(seeded_count) + points.drop(seeded_count).each_slice(2).with_object([]) {|((x1, y1), (x2, y2)), ps| ps << [(x1 + x2) / 2, y] }
  end

  while points.size > 1
    y -= 20
    points.each_slice(2) do |(x1, y1), (x2, y2)|
      svg.push "  %path{d: 'M #{x1} #{y1} L #{x1} #{y}', stroke: 'black', fill: 'none'}"
      svg.push "  %path{d: 'M #{x2} #{y2} L #{x2} #{y}', stroke: 'black', fill: 'none'}"
      svg.push "  %path{d: 'M #{x1} #{y} L #{x2} #{y}', stroke: 'black', fill: 'none'}"
    end
    points = points.each_slice(2).with_object([]) {|((x1, y1), (x2, y2)), ps| ps << [(x1 + x2) / 2, y] }
  end

  y -= 20
  svg.push "  %path{d: 'M #{points.first[0]} #{points.first[1]} L #{points.first[0]} #{y}', stroke: 'black', fill: 'none'}"
  svg.push "  %text{x: #{points.first[0]}, y: #{y - 5}, 'font-family' => 'Arial', 'font-size' => 8, fill: 'black', 'text-anchor' => 'middle'} #{expected}"

  svg.unshift "%svg{xmlns: 'http://www.w3.org/2000/svg', 'xmlns:xlink' => 'http://www.w3.org/1999/xlink', viewBox: '0 0 #{players.size * 20} #{level * 20 + 120}', width: '100%', height: '100%'}"
end

DATA.each_with_index do |line, i|
  input, expected = line.strip.split
  filename = 'tournament%02d' % i
  File.write("images/#{filename}.haml", to_svg(input, expected).join("\n"))
  `haml images/#{filename}.haml images/#{filename}.svg`
  `convert -density 720 -font /Library/Fonts/Arial.ttf images/#{filename}.svg images/#{filename}.png`
end


__END__
(RSP)(R)(RPS)(SP) (RPS)
(RPS)(R)(RSP)(SP)(RSSP) (RSSP)
(RRS)(S)(PSSRP)(PRP)(PSS) (PRP)
(PRS)(PSPP)(PRSP)(S)(RR)(SSPR) (PRS)
(PSRP)(PR)(RPRPR)(PSSPP)(SP)(SRPP)(PR) (SP)
(SPS)(R)(RP)(RRS)(PPRRS)(R)(RS)(RRRRP) (PPRRS)
(PPSRPSPRR)(SP)(PPPRSSR)(PS)(P)(PRSPS)(PP)(RSSR) (SP)
(SRPRS)(SRPSRS)(SPP)(RSPRS)(S)(SRPSPS)(RSPPSSS)(SRRPRRPSSP) (RSPPSSS)
(SRSPSPRS)(RRPRRS)(PRRRRS)(RSSPSSRPS)(PPSSPPRR)(PPSPPS)(PSPSPSSSP)(RPPRPS) (PRRRRS)
(S)(PRS)(RSRP)(S)(PPRR)(PP)(RSSS)(P)(RSR) (PP)
(RPR)(P)(PSPR)(SRSRP)(SR)(RPPR)(RRS)(S)(SSPR)(PRPR) (RPPR)
(PSR)(PPPRR)(S)(SP)(S)(PR)(SPSRP)(PPSRR)(PRPPR)(RRRSP)(SR) (S)
(PPRPP)(RSS)(PRS)(R)(RPRP)(SPSSS)(RR)(PPRP)(RSSS)(RSRS)(RP) (PPRPP)
(P)(PPPRR)(RRRS)(RR)(RPRSS)(PRSPS)(PP)(R)(PSR)(RPPP)(RP)(SSSR) (PSR)
(SR)(P)(RRPRP)(RSPS)(PSS)(SPPSP)(RRPS)(PR)(RRRSR)(PRR)(SSS)(RRRSS)(P) (SR)
(PS)(RS)(RR)(RPR)(SR)(SP)(PRP)(PPS)(R)(PRSP)(SSPRR)(SP)(PPR)(RSRR) (SSPRR)
(RRRRS)(SRPRR)(PPSS)(SSPPS)(R)(R)(P)(P)(PSSPR)(S)(RRPP)(SPRR)(S)(RR)(S) (PSSPR)
(RRPSSRP)(SSSSSP)(RRSPSS)(PRSRRSRP)(SSRRRRR)(SS)(SSSSSSPPRP)(R)(SRRSR)(PPPSRSP)(RPRS)(RSRPPRS)(RPPPPRPR)(PRRSR)(RPRRSR) (PPPSRSP)
(SSSRS)(SRPSS)(RSPRP)(RPPPP)(S)(PPRPS)(RRR)(PS)(RPSPS)(SPP)(PSRS)(P)(P)(RR)(S)(PSP) (RSPRP)
(SPP)(PR)(SR)(SRPSP)(P)(RR)(SSPP)(RS)(RRRPP)(R)(PRSPS)(RRPP)(RRRSS)(RRRSS)(RSP)(SRPR)(PPS) (SPP)
(SSS)(SSPR)(SSRR)(P)(PRRSP)(RRRPP)(PR)(P)(PS)(PPR)(R)(SRPSR)(R)(S)(SSPRS)(SRPR)(PPPR)(SRS) (SSRR)
(PR)(R)(PRPS)(PR)(S)(PS)(R)(P)(R)(SS)(RP)(SS)(SP)(R)(SPR)(RPR)(PSP)(PPPS)(SPRPR) (RP)
(SPS)(SRPR)(P)(SPPS)(SS)(RS)(SRPPS)(SRSPS)(RSR)(SRPR)(P)(SPSS)(SRS)(SP)(RSRRP)(PP)(SR)(RPRP)(P)(SPPPS) (RSR)
(SSRSP)(SPRRPRSPS)(SPSPS)(PRPR)(SPPRP)(RS)(SPSSPRRS)(PSPPRPSSP)(PSRRRRRP)(SPPRS)(SRRP)(SP)(SRSPRPSP)(PPSRRRSR)(PPPSSRSR)(PRPSPS)(SRR)(RP)(SP)(RSRPSPSSRS) (RS)
(RRPS)(SRPR)(PS)(SPPS)(SS)(RS)(SRPPS)(SRSPS)(RSR)(SRPR)(P)(SPSS)(SRS)(SP)(RSRRP)(PP)(SR)(RPRP)(P)(SPPPS) (RRPS)
(S)(PRSRR)(PP)(PSSSS)(SR)(SRRP)(PRRPR)(PRSS)(SPPS)(SS)(SPPR)(SSRSR)(PSRPP)(RSP)(R)(P)(PPP)(SS)(SP)(SSSS)(RRSR) (SRRP)
(PS)(R)(R)(S)(S)(SSP)(RPPP)(RPSP)(RPRR)(R)(SRRSS)(RSR)(PS)(PRP)(SSSS)(S)(SSSR)(SS)(PSP)(RS)(PSRSR)(SR) (SR)
(RSPSS)(RRSSR)(S)(RRS)(PSSRR)(S)(RPRRP)(RS)(PS)(RR)(R)(PSRR)(RPPRP)(SSS)(S)(R)(R)(SRSS)(PR)(S)(RRPPS)(S)(SSPRR) (RRS)
(PSSS)(RRRPR)(PRPP)(RSSS)(RR)(RP)(PPS)(PSR)(SPS)(SRSS)(R)(RR)(SPRSR)(RSPRP)(RRSP)(SSRRP)(RSSSR)(PPSS)(PRS)(RRSRS)(PS)(SS)(P)(SPR) (PRPP)
(RSRPSS)(RPPRPRRSP)(PRPSRSRPPP)(SSRSSRS)(RPS)(SP)(PPPPPSSP)(RRRPSR)(PSR)(SRSRSSR)(RPSSSRP)(RRSPSSSPPR)(RS)(SRRRSPRP)(PR)(RSSRPSSS)(PPRRRRRR)(RRSRP)(RRR)(PSPRSSPRP)(PRPPRSSRP)(SPPSPSS)(PSS)(RPS)(P)(RRSRSP)(PS)(RRPSSSRR)(RR)(PPPSPRPR)(PS)(PRSSRPR)(RRP)(PSRPR)(PS)(R)(RRPP)(SSPPSS)(SRPSSS)(RRSRRPRPP) (SPPSPSS)
