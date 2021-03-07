/**
 * vim: set ts=4 :
 * =============================================================================
 * Randomize Teams
 * Randomize team slots for Fistful of Frags.  This allows for 2-Team Shootouts
 * that are not always Vigilantes vs Desperados.
 *
 * Copyright 2015 Crimsontautology
 * =============================================================================
 *
 */

#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#define PLUGIN_VERSION "1.10.0"
#define PLUGIN_NAME "[FoF] Randomize Teams"

public Plugin myinfo =
{
    name = PLUGIN_NAME,
    author = "CrimsonTautology",
    description = "Randomize the team names for Fistful of Frags",
    version = PLUGIN_VERSION,
    url = "https://github.com/CrimsonTautology/sm-randomize-teams-fof"
};

#define MAX_TEAMS 4

public void OnPluginStart()
{
    CreateConVar(
            "sm_randomize_teams_version", PLUGIN_VERSION, PLUGIN_NAME,
            FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_DONTRECORD
            );

    RegAdminCmd(
            "sm_randomize_teams", Command_RandomizeTeams, ADMFLAG_SLAY,
            "Randomize the team slots"
            );
}

Action Command_RandomizeTeams(int client, int args)
{
    RandomizeTeams();

    return Plugin_Handled;
}

void RandomizeTeams()
{
    // modified Fisher-Yates
    int team_slot, rand;
    int team_slots[] = {0, 2, 3, 4, 5};

    for (int team = 1; team <= MAX_TEAMS; team++)
    {
        rand = GetRandomInt(team, MAX_TEAMS);

        team_slot = team_slots[rand];
        team_slots[rand] = team_slots[team];
        team_slots[team] = team_slot;

        TeamRemap(rand, team_slots[rand]);
        TeamRemap(team, team_slots[team]);
    }
}

void TeamRemap(int team, int team_slot)
{
    // fof_sv_team_remap_[1-4] : reassign a team to team slot [1-4]:
    // 2-vigilantes, 3-desperados, 4-bandidos, 5-rangers
    ServerCommand("fof_sv_team_remap_%d \"%d\"", team, team_slot);
}
