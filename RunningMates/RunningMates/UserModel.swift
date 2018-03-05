//
//  UserModel.swift
//  RunningMates
//
//  Created by dali on 3/5/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

struct UserModel {
    let firstName: String
    let lastName: String
    let imageURL: String
    let images: [{ data: Buffer, contentType: String }]
    let bio: String
    let gender: String
    let age: Number
    let location: {
    let type: []
    let index: { type: '2dsphere', sparse: true },
    default: [0, 0],
    },
    swipes: { count: Number, date: String },
    mates: [],
    potentialMates: [],
    blockedMates: [],
    seenProfiles: [{ userID: Number, date: String }],
    email: { type: String, unique: true, lowercase: true },
    password: String,
    token: String,
    preferences: {
    gender: String,
    pace: [], // Range [slowestPace, fastestPace]
    age: [], // Range [minAge, maxAge]
    proximity: Number,
    },
    thirdPartyIds: {},
    data: {
    totalMilesRun: Number,
    totalElevationClimbed: Number,
    AveragePace: Number,
    Koms: [],
    frequentSegments: [],
    racesDone: [],
    longestRun: String,
    },
},
}
