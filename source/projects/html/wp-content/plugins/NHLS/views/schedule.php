<div id="nhl-schedule-container">
<button id="sendProjectData">Send Project Data</button>
<button id="refresh-schedule">Refresh Schedule</button>
    <div class="table-wrapper">
        <table>
            <tr>
                <th>Date</th>
                <th>Time (UTC)</th>
                <th>Venue</th>
                <th>Home Team</th>
                <th>Away Team</th>
                <th>Broadcast</th>
                <th>Tickets</th>
                <th>Game Center</th>
            </tr>
            <?php foreach ($scheduleData['games'] as $game): ?>
                <?php
                $gameDate = date('Y-m-d', strtotime($game['gameDate']));
                $startTime = date('H:i', strtotime($game['startTimeUTC']));
                $venue = htmlspecialchars($game['venue']['default']);
                $homeTeam = htmlspecialchars($game['homeTeam']['placeName']['default']);
                $homeTeamAbbrev = htmlspecialchars($game['homeTeam']['abbrev']);
                $homeTeamLogo = htmlspecialchars($game['homeTeam']['logo']);
                $awayTeam = htmlspecialchars($game['awayTeam']['placeName']['default']);
                $awayTeamAbbrev = htmlspecialchars($game['awayTeam']['abbrev']);
                $awayTeamLogo = htmlspecialchars($game['awayTeam']['logo']);
                $ticketsLink = htmlspecialchars($game['ticketsLink']);
                $gameCenterLink = htmlspecialchars($game['gameCenterLink']);
                ?>
                <tr>
                    <td><?= $gameDate; ?></td>
                    <td><?= $startTime; ?></td>
                    <td><?= $venue; ?></td>
                    <td>
                        <img src="<?= $homeTeamLogo; ?>" alt="<?= $homeTeam; ?> Logo">
                        <?= $homeTeam; ?> (<?= $homeTeamAbbrev; ?>)
                    </td>
                    <td>
                        <img src="<?= $awayTeamLogo; ?>" alt="<?= $awayTeam; ?> Logo">
                        <?= $awayTeam; ?> (<?= $awayTeamAbbrev; ?>)
                    </td>
                    <td>
                        <?php if (isset($game['tvBroadcasts']) && is_array($game['tvBroadcasts'])): ?>
                            <?php foreach ($game['tvBroadcasts'] as $broadcast): ?>
                                <?= htmlspecialchars($broadcast['network']); ?> 
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </td>
                    <td><a href="<?= $ticketsLink; ?>">Tickets</a></td>
                    <td><a href="https://www.nhl.com<?= $gameCenterLink; ?>">Game Center</a></td>
                </tr>
            <?php endforeach; ?>
        </table>
    </div>
</div>

