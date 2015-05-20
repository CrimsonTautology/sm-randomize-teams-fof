/**
 * vim: set ts=4 :
 * =============================================================================
 * Randomize Teams
 * Randomize team slots for Fistful of Frags.  This allows for 2-Team Shootouts
 * that are not allways Vigilantes vs Desperados.
 *
 * Copyright 2015 Crimsontautology
 * =============================================================================
 *
 */

#pragma semicolon 1

#include <sourcemod>

#define PLUGIN_VERSION "1.0.0"
#define PLUGIN_NAME "[FoF] Randomize Teams"

public Plugin:myinfo =
{
    name = PLUGIN_NAME,
    author = "CrimsonTautology",
    description = "Randomize the team names for Fistful of Frags",
    version = PLUGIN_VERSION,
    url = "https://github.com/CrimsonTautology/sm_randomize_teams"
};

#define MAX_TEAMS 4

public OnPluginStart()
{
    CreateConVar("sm_randomize_teams_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_DONTRECORD);
    RegAdminCmd("sm_randomize_teams", Command_RandomizeTeams, ADMFLAG_SLAY, "Randomize the team slots");
}

public Action:Command_RandomizeTeams(client, args)
{
    RandomizeTeams();

    return Plugin_Handled;
}

RandomizeTeams()
{
    new team_slot, rand;
    new team_slots[] = { 0,2,3,4,5 };
    for(new team=1; team <= MAX_TEAMS; team++)
    {
        rand = GetRandomInt(team, MAX_TEAMS);

        team_slot        = team_slots[rand];
        team_slots[rand] = team_slots[team];
        team_slots[team] = team_slot;

        TeamRemap(rand, team_slots[rand]);
        TeamRemap(team, team_slots[team]);
    }
}

//fof_sv_team_remap_[1-4] : reassign a team to team slot 1: 2-vigilantes, 3-desperados, 4-bandidos, 5-rangers
TeamRemap(team, team_slot)
{
    assert(team >= 1 && team <= 4);
    assert(team_slot >= 2 && team_slot <= 5);

    ServerCommand("fof_sv_team_remap_%d \"%d\"", team, team_slot);
}

